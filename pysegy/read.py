"""
Reading utilities for the minimal Python SEGY implementation.
"""

from .types import (
    BinaryFileHeader,
    BinaryTraceHeader,
    FileHeader,
    SeisBlock,
    FH_BYTE2SAMPLE,
    TH_BYTE2SAMPLE,
    TH_INT32_FIELDS,
)
from typing import BinaryIO, Iterable, List, Optional, Tuple
import asyncio
import numpy as np
from concurrent.futures import ThreadPoolExecutor

from . import logger

from .ibm import ibm_to_ieee
import struct

# Number of traces to read at a time when loading an entire file
TRACE_CHUNKSIZE = 512


def read_fileheader(
    f: BinaryIO, keys: Optional[Iterable[str]] = None, bigendian: bool = True
) -> FileHeader:
    """
    Read and parse the binary file header.

    Parameters
    ----------
    f : BinaryIO
        Open binary file handle.
    keys : Iterable[str], optional
        Header fields to read; by default all are loaded.
    bigendian : bool, optional
        ``True`` when the file is big-endian, ``False`` otherwise.

    Returns
    -------
    FileHeader
        Object containing the textual and binary headers.
    """
    if keys is None:
        keys = list(FH_BYTE2SAMPLE.keys())
    start = f.tell()
    f.seek(0)
    text_header = f.read(3600)
    bfh = BinaryFileHeader()
    for k in keys:
        offset = FH_BYTE2SAMPLE[k]
        # all fields are 2 or 4 bytes integers
        size = 4 if k in ("Job", "Line", "Reel") else 2
        fmt = ">i" if size == 4 else ">h"
        if not bigendian:
            fmt = "<i" if size == 4 else "<h"
        val_bytes = text_header[offset:offset+size]
        val = struct.unpack(fmt, val_bytes)[0]
        setattr(bfh, k, val)
    bfh.keys_loaded = list(keys)
    f.seek(start)
    return FileHeader(text_header[:3200], bfh)


def read_traceheader(
    f: BinaryIO, keys: Optional[Iterable[str]] = None, bigendian: bool = True
) -> BinaryTraceHeader:
    """
    Read a single binary trace header from ``f``.

    Parameters
    ----------
    f : BinaryIO
        Open binary file handle positioned at a trace header.
    keys : Iterable[str], optional
        Header fields to read; all are loaded when omitted.
    bigendian : bool, optional
        ``True`` for big-endian encoding.

    Returns
    -------
    BinaryTraceHeader
        Parsed header object.
    """
    if keys is None:
        keys = list(TH_BYTE2SAMPLE.keys())
    hdr_bytes = f.read(240)
    th = BinaryTraceHeader()
    for k in keys:
        offset = TH_BYTE2SAMPLE[k]
        size = 4 if k in TH_INT32_FIELDS else 2
        fmt = ">i" if size == 4 else ">h"
        if not bigendian:
            fmt = "<i" if size == 4 else "<h"
        val = struct.unpack(fmt, hdr_bytes[offset:offset + size])[0]
        setattr(th, k, val)
    th.keys_loaded = list(keys)
    return th


def read_traces(
    f: BinaryIO,
    ns: int,
    ntraces: int,
    datatype: int,
    keys: Optional[Iterable[str]] = None,
    bigendian: bool = True,
) -> Tuple[List[BinaryTraceHeader], List[List[float]]]:
    """
    Read ``ntraces`` traces and their headers from ``f``.

    Parameters
    ----------
    f : BinaryIO
        Open file handle positioned at the first trace.
    ns : int
        Number of samples per trace.
    ntraces : int
        Number of traces to read.
    datatype : int
        SEGY data sample format code.
    keys : Iterable[str], optional
        Header fields to read for each trace.
    bigendian : bool, optional
        ``True`` for big-endian encoding.

    Returns
    -------
    tuple
        ``(headers, data)`` where ``headers`` is a list of
        :class:`BinaryTraceHeader` and ``data`` is ``ns`` x ``ntraces`` array.
    """
    data: np.ndarray = np.zeros((ns, ntraces), dtype=np.float32)
    headers: List[BinaryTraceHeader] = [
        BinaryTraceHeader() for _ in range(ntraces)
    ]

    trace_size = 240 + ns * 4
    raw = f.read(trace_size * ntraces)

    if keys is None:
        keys = list(TH_BYTE2SAMPLE.keys())
    key_list = list(keys)

    def parse_one(idx: int):
        offset = idx * trace_size
        hdr_buf = raw[offset:offset + 240]
        hdr = BinaryTraceHeader()
        for k in key_list:
            offset_k = TH_BYTE2SAMPLE[k]
            size = 4 if k in TH_INT32_FIELDS else 2
            fmt = ">i" if size == 4 else ">h"
            if not bigendian:
                fmt = "<i" if size == 4 else "<h"
            val = struct.unpack_from(fmt, hdr_buf, offset_k)[0]
            setattr(hdr, k, val)
        hdr.keys_loaded = key_list

        data_buf = raw[offset + 240:offset + trace_size]
        if datatype == 1:
            samples = [
                ibm_to_ieee(data_buf[j:j + 4])
                for j in range(0, ns * 4, 4)
            ]
        else:
            fmt = (">%df" % ns) if bigendian else ("<%df" % ns)
            samples = struct.unpack(fmt, data_buf)
        return idx, hdr, samples

    with ThreadPoolExecutor() as pool:
        for idx, hdr, samples in pool.map(parse_one, range(ntraces)):
            headers[idx] = hdr
            data[:, idx] = samples

    return headers, data

def read_file(
    f: BinaryIO,
    warn_user: bool = True,
    keys: Optional[Iterable[str]] = None,
    bigendian: bool = True,
    workers: int = 5,
) -> SeisBlock:
    """
    Read a complete SEGY file from an open file handle.

    Parameters
    ----------
    f : BinaryIO
        File object to read from.
    warn_user : bool, optional
        Currently unused.
    keys : Iterable[str], optional
        Additional header fields to load with each trace.
    bigendian : bool, optional
        Set ``True`` for big-endian encoding.
    workers : int, optional
        Unused parameter kept for backwards compatibility.

    Returns
    -------
    SeisBlock
        Entire dataset loaded into memory. The file is read in chunks of
        ``TRACE_CHUNKSIZE`` traces to limit peak memory usage.
    """
    fh = read_fileheader(f, bigendian=bigendian)
    ns = fh.bfh.ns
    dsf = fh.bfh.DataSampleFormat
    trace_size = 240 + ns * 4
    f.seek(0, 2)
    end = f.tell()
    ntraces = (end - 3600) // trace_size
    f.seek(3600)
    headers: List[BinaryTraceHeader] = [BinaryTraceHeader() for _ in range(ntraces)]
    data: np.ndarray = np.zeros((ns, ntraces), dtype=np.float32)

    idx = 0
    while idx < ntraces:
        count = min(TRACE_CHUNKSIZE, ntraces - idx)
        h, d = read_traces(
            f, ns, count, dsf, keys, bigendian
        )
        for j in range(count):
            headers[idx + j] = h[j]
            data[:, idx + j] = d[:, j]
        idx += count

    return SeisBlock(fh, headers, data)


def segy_read(
    path: str,
    keys: Optional[Iterable[str]] = None,
    workers: int = 5,
    fs=None,
) -> SeisBlock:
    """
    Convenience wrapper to read a SEGY file.

    Parameters
    ----------
    path : str
        File system path to the SEGY file. When ``fs`` is provided the
        path is interpreted relative to that filesystem.
    fs : filesystem-like object, optional
        Filesystem providing ``open`` if reading from non-local storage.
    keys : Iterable[str], optional
        Additional header fields to load with each trace.

    Returns
    -------
    SeisBlock
        Loaded dataset.
    """
    logger.info("Reading SEGY file %s", path)

    opener = fs.open if fs is not None else open

    with opener(path, "rb") as f:
        block = read_file(f, keys=keys, workers=workers)
    logger.info(
        "Loaded header ns=%d dt=%d from %s",
        block.fileheader.bfh.ns,
        block.fileheader.bfh.dt,
        path,
    )
    return block

import math
hot_lpns = {}


def update_var(offset, offset_scale, page_size, size):
    page_size = float(page_size)
    size = int(size)
    offset = int(offset) * offset_scale

    lpns = [lpn for lpn in range(int(math.floor(offset/page_size)), int(math.ceil((offset+size)/page_size)))]

    for lpn in lpns:
        hot_lpns[lpn] = 1
def parse_version(version_str):
    parts = version_str.split(".")
    if len(parts) != 3:
        fail("invalid version string: {}".format(version_str))

    major, minor, patch = parts

    if int(minor) >= 100 or int(patch) >= 100:
        fail("minor and patch versions must be less than 100: {}".format(version_str))

    return int(major) * 10000 + int(minor) * 100 + int(patch)

DISTRIBS = {
    "2025.22.1": [
        {
            "os": "windows",
            "arch": "x86_64",
            "url": "https://github.com/shader-slang/slang/releases/download/v2025.22.1/slang-2025.22.1-windows-x86_64.tar.gz",
            "sha256": "bafeae35fb06101143c6d70aecf01b2122c14ea138809e778eabf0e7073402c3",
        },
        {
            "os": "linux",
            "arch": "x86_64",
            "url": "https://github.com/shader-slang/slang/releases/download/v2025.22.1/slang-2025.22.1-linux-x86_64.tar.gz",
            "sha256": "1da353e3130a13050927245cfaba16cb8a6d9574e7b3b8a89ec30acba357f2b9",
        },
    ],
    "2025.23.1": [
        {
            "os": "windows",
            "arch": "x86_64",
            "url": "https://github.com/shader-slang/slang/releases/download/v2025.23.1/slang-2025.23.1-windows-x86_64.tar.gz",
            "sha256": "3647119b6a747a23a81b4215b0cbc7e08bc44e023381a9fefc0056565d706016",
        },
        {
            "os": "linux",
            "arch": "x86_64",
            "url": "https://github.com/shader-slang/slang/releases/download/v2025.23.1/slang-2025.23.1-linux-x86_64.tar.gz",
            "sha256": "a79f99da5fa7800ca2d87bf63ab1516d03e2ac23b4a3bfea8955b657897d9b73",
        },
    ],
}

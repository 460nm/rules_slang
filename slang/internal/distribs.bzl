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
            "sha256": "b592c2ca8404f0a587633a7a1cfce35e2ab516f4a65cf5f148905b41e88fd61f",
        },
    ],
}

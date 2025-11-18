load("//slang/internal:slang_download.bzl", "slang_download")

def _slang_impl(ctx):
    slang_download(
        name = "slang_toolchain",
        urls = [
            "https://github.com/shader-slang/slang/releases/download/v2025.22.1/slang-2025.22.1-windows-x86_64.tar.gz",
        ],
        sha256 = "bafeae35fb06101143c6d70aecf01b2122c14ea138809e778eabf0e7073402c3",
        os = "windows",
        arch = "x86_64",
    )

slang = module_extension(
    implementation = _slang_impl,
    os_dependent = False,
    arch_dependent = False,
)

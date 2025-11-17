_BUILD_FILE_CONTENT = """
load("@bazel_skylib//rules:native_binary.bzl", "native_binary")
load("@bazel_skylib//rules:copy_file.bzl", "copy_file")

copy_file(
    name = "slang_compiler_dll",
    src = "bin/slang-compiler.dll",
    out = "slang-compiler.dll",
)

copy_file(
    name = "slang_glslang_dll",
    src = "bin/slang-glslang.dll",
    out = "slang-glslang.dll",
)

native_binary(
    name = "slangc",
    src = "bin/slangc.exe",
    data = [
        ":slang_compiler_dll",
        ":slang_glslang_dll",
    ],
    visibility = ["//visibility:public"],
)
"""

def slang_download_impl(ctx):
    ctx.report_progress("downloading Slang")

    download_success = False
    for url in ctx.attr.urls:
        ret = ctx.download_and_extract(
            url = url,
            sha256 = ctx.attr.sha256,
        )

        if ret.success:
            download_success = True
            break

    if not download_success:
        fail("failed to download and extract Slang from provided URLs")

    ctx.file("BUILD.bazel", _BUILD_FILE_CONTENT)

slang_download = repository_rule(
    implementation = slang_download_impl,
    attrs = {
        "urls": attr.string_list(mandatory = True),
        "sha256": attr.string(mandatory = True),
    },
)

_BUILD_FILE_CONTENT = """
load("@rules_slang//slang/internal:toolchain.bzl", "slang_toolchain")

slang_toolchain(
    name = "slang_toolchain",
    slangc = "bin/slangc%{exe}",
)

toolchain(
    name = "toolchain",
    exec_compatible_with = [
        "@platforms//os:%{os}",
        "@platforms//cpu:%{arch}",
    ],
    toolchain_type = "@rules_slang//slang:toolchain_type",
    toolchain = ":slang_toolchain",
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

    build_file_content = _BUILD_FILE_CONTENT \
        .replace("%{os}", ctx.attr.os) \
        .replace("%{arch}", ctx.attr.arch) \
        .replace("%{exe}", ".exe" if ctx.attr.os == "windows" else "")

    ctx.file("BUILD.bazel", build_file_content)

slang_download = repository_rule(
    implementation = slang_download_impl,
    attrs = {
        "urls": attr.string_list(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "os": attr.string(
            mandatory = True,
            values = ["windows"],
        ),
        "arch": attr.string(
            mandatory = True,
            values = ["x86_64"],
        ),
    },
)

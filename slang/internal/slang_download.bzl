_BUILD_FILE_CONTENT = """
alias(
    name = "slangc",
    actual = "bin/slangc%{exe}",
    visibility = ["//visibility:public"],
)
"""

def _slang_download_impl(ctx):
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
        .replace("%{exe}", ".exe" if ctx.attr.os == "windows" else "")

    ctx.file("BUILD.bazel", build_file_content)

slang_download = repository_rule(
    implementation = _slang_download_impl,
    attrs = {
        "urls": attr.string_list(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "os": attr.string(
            mandatory = True,
            values = ["windows", "linux"],
        ),
    },
)

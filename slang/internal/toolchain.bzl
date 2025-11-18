def _slang_toolchain_impl(ctx):
    return [platform_common.ToolchainInfo(
        slangc = ctx.file.slangc,
    )]

slang_toolchain = rule(
    implementation = _slang_toolchain_impl,
    attrs = {
        "slangc": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
    },
)

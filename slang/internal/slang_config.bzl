load(":providers.bzl", "SlangConfigProvider")

TARGET_TO_FLAGS = {
    "spirv_1_6": [
        "-target",
        "spirv",
        "-profile",
        "spirv_1_6",
    ],
}

def _slang_config_impl(ctx):
    return [SlangConfigProvider(
        target = ctx.attr.target,
    )]

slang_config = rule(
    implementation = _slang_config_impl,
    attrs = {
        "target": attr.string(
            default = "spirv_1_6",
            doc = "The target platform for the slang configuration.",
            values = list(TARGET_TO_FLAGS.keys()),
        ),
    },
)

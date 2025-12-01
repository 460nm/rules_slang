load(":providers.bzl", "SlangConfigProvider")

TARGET_TO_FLAGS = {
    "spirv_1_6": [
        "-target",
        "spirv",
        "-profile",
        "spirv_1_6",
    ],
}

TARGET_TO_EXTENSIONS = {
    "spirv_1_6": "spv",
}

def _slang_config_impl(ctx):
    extension = ctx.attr.extension.lstrip(".")
    if extension == "":
        extension = TARGET_TO_EXTENSIONS[ctx.attr.target]

    return [SlangConfigProvider(
        target = ctx.attr.target,
        extension = extension,
    )]

slang_config = rule(
    implementation = _slang_config_impl,
    attrs = {
        "target": attr.string(
            default = "spirv_1_6",
            doc = "The target platform for the slang configuration.",
            values = list(TARGET_TO_FLAGS.keys()),
        ),
        "extension": attr.string(
            mandatory = False,
            doc = "The file extension for the target platform.",
        ),
    },
)

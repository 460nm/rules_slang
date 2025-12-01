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

SOURCE_EMBED_TYPE_INFO = {
    "cpp_u32": {
        "language": "cpp",
        "style": "u32",
        "extension": "inl.h",
    },
}

def _slang_config_impl(ctx):
    extension = ctx.attr.extension
    emit_source_embed = False
    source_embed_style = ""
    source_embed_language = ""
    source_embed_name_prefix = ""
    source_embed_name_suffix = ""

    if ctx.attr.source_embed_type:
        emit_source_embed = True
        info = SOURCE_EMBED_TYPE_INFO[ctx.attr.source_embed_type]
        source_embed_style = info["style"]
        source_embed_language = info["language"]

        if extension == "":
            extension = info["extension"]
    elif extension == "":
        extension = TARGET_TO_EXTENSIONS[ctx.attr.target]

    return [SlangConfigProvider(
        target = ctx.attr.target,
        extension = extension,
        emit_source_embed = emit_source_embed,
        source_embed_style = source_embed_style,
        source_embed_language = source_embed_language,
        source_embed_name_prefix = source_embed_name_prefix,
        source_embed_name_suffix = source_embed_name_suffix,
    )]

slang_config = rule(
    implementation = _slang_config_impl,
    attrs = {
        "target": attr.string(
            default = "spirv_1_6",
            values = list(TARGET_TO_FLAGS.keys()),
        ),
        "extension": attr.string(
            mandatory = False,
        ),
        "source_embed_type": attr.string(
            mandatory = False,
            values = list(SOURCE_EMBED_TYPE_INFO.keys()),
        ),
    },
)

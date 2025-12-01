SlangModuleProvider = provider(
    fields = {
        "module_file": "The compiled slang module file.",
        "root_path": "The root path of the module.",
        "deps_module_files": "The transitive set dependencies's module files.",
        "deps_root_paths": "The transitive set of dependencies' root paths.",
    },
)

SlangConfigProvider = provider(
    fields = {
        "target": "The target platform for the slang configuration.",
        "extension": "The file extension.",
        "emit_source_embed": "Whether to emit source embed code.",
        "source_embed_style": "The style of source embed code.",
        "source_embed_language": "The programming language for source embed code.",
        "source_embed_name_prefix": "The prefix for source embed variable names.",
        "source_embed_name_suffix": "The suffix for source embed variable names.",
    },
)

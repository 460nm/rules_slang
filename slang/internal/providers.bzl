SlangModuleProvider = provider(
    fields = {
        "module_file": "The compiled slang module file.",
        "root_path": "The root path of the module.",
        "deps_module_files": "The transitive set dependencies's module files.",
        "deps_root_paths": "The transitive set of dependencies' root paths.",
    },
)

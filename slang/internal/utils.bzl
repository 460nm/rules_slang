load("providers.bzl", "SlangModuleProvider")

def gather_deps_module_files(deps):
    return depset(direct = [
        dep[SlangModuleProvider].module_file for dep in deps
    ], transitive = [
        dep[SlangModuleProvider].deps_module_files for dep in deps
    ])

def gather_deps_root_paths(deps):
    return depset(direct = [
        dep[SlangModuleProvider].root_path for dep in deps
    ], transitive = [
        dep[SlangModuleProvider].deps_root_paths for dep in deps
    ])

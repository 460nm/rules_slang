load("providers.bzl", "SlangModuleProvider")

def gather_deps_module_files(deps):
    return depset(direct = [
        dep[SlangModuleProvider].module_file for dep in deps
    ], transitive = [
        dep[SlangModuleProvider].deps for dep in deps
    ])

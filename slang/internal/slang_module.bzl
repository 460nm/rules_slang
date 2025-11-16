load(":actions.bzl", "compile_module")
load(":providers.bzl", "SlangModuleProvider")
load(":utils.bzl", "gather_deps_module_files", "gather_deps_root_paths")

def _slang_module_impl(ctx):
    output_module_file_name = "{name}.slang-module".format(name = ctx.label.name)
    output_module_file = ctx.actions.declare_file(output_module_file_name)

    deps_module_files = gather_deps_module_files(ctx.attr.deps)
    deps_root_paths = gather_deps_root_paths(ctx.attr.deps)

    compile_module(ctx, ctx.files.srcs, deps_module_files, deps_root_paths, output_module_file, ctx.executable._slangc)

    root_path = output_module_file.root.path
    if ctx.label.workspace_root:
        root_path += "/" + ctx.label.workspace_root

    return [DefaultInfo(
        files = depset([output_module_file]),
    ), SlangModuleProvider(
        module_file = output_module_file,
        root_path = root_path,
        deps_module_files = deps_module_files,
        deps_root_paths = deps_root_paths,
    )]

slang_module = rule(
    implementation = _slang_module_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
        ),
        "deps": attr.label_list(
            providers = [SlangModuleProvider],
        ),
        "_slangc": attr.label(
            executable = True,
            cfg = "exec",
            default = "@slang_toolchain//:slangc",
        ),
    },
)

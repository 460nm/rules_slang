load(":actions.bzl", "compile_module", "link_shader")
load(":providers.bzl", "SlangModuleProvider")
load(":utils.bzl", "gather_deps_module_files", "gather_deps_root_paths")

def _slang_shader_impl(ctx):
    deps_modules = gather_deps_module_files(ctx.attr.deps)
    deps_root_paths = gather_deps_root_paths(ctx.attr.deps)

    output_module_file_name = "{name}.slang-module".format(name = ctx.label.name)
    output_module_file = ctx.actions.declare_file(output_module_file_name)
    compile_module(ctx, ctx.files.srcs, deps_modules, deps_root_paths, output_module_file, ctx.executable._slangc)

    output_shader_file_name = "{name}.spv".format(name = ctx.label.name)
    output_shader_file = ctx.actions.declare_file(output_shader_file_name)

    modules = depset(direct = [output_module_file], transitive = [deps_modules])
    modules_list = modules.to_list()

    link_shader(ctx, modules_list, output_shader_file, ctx.executable._slangc)

    return [DefaultInfo(
        files = depset([output_shader_file]),
    )]

slang_shader = rule(
    implementation = _slang_shader_impl,
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

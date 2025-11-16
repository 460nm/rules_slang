load(":actions.bzl", "compile_module")
load(":providers.bzl", "SlangModuleProvider")
load(":utils.bzl", "gather_deps_module_files")

def _slang_module_impl(ctx):
    output_module_file_name = "{name}.slang-module".format(name = ctx.label.name)
    output_module_file = ctx.actions.declare_file(output_module_file_name)

    deps = gather_deps_module_files(ctx.attr.deps)
    compile_module(ctx, ctx.files.srcs, deps, output_module_file, ctx.executable._slangc)

    return [DefaultInfo(
        files = depset([output_module_file]),
    ), SlangModuleProvider(
        module_file = output_module_file,
        deps = deps,
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

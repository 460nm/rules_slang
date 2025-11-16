load(":actions.bzl", "compile_module")
load(":providers.bzl", "SlangModuleProvider")

def _slang_module_impl(ctx):
    output_module_file_name = "{name}.slang-module".format(name = ctx.label.name)
    output_module_file = ctx.actions.declare_file(output_module_file_name)

    compile_module(ctx, ctx.files.srcs, output_module_file, ctx.executable._slangc)

    deps = depset(direct = [
        dep[SlangModuleProvider].module_file for dep in ctx.attr.deps
    ], transitive = [
        dep[SlangModuleProvider].deps for dep in ctx.attr.deps
    ])

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

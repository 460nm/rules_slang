def _slang_shader_impl(ctx):
    output_spv_file = ctx.actions.declare_file("{name}.spv".format(name = ctx.label.name))

    args = ctx.actions.args()
    args.add_all(["-target", "spirv"])
    args.add_all(["-profile", "spirv_1_6"])
    args.add_all(["-o", output_spv_file.path])
    args.add("--")
    args.add_all(ctx.files.srcs)

    ctx.actions.run(
        outputs = [output_spv_file],
        inputs = ctx.files.srcs,
        executable = ctx.executable._slangc,
        arguments = [args],
        mnemonic = "SlangCompile",
        progress_message = "Compiling shader %{output}",
    )

    return [DefaultInfo(
        files = depset([output_spv_file]),
    )]

slang_shader = rule(
    implementation = _slang_shader_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
        ),
        "_slangc": attr.label(
            executable = True,
            cfg = "exec",
            default = "@slang_toolchain//:slangc",
        ),
    },
)
    

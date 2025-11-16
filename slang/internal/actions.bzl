def compile_module(ctx, srcs, output_module_file, slangc):
    args = ctx.actions.args()
    args.add_all(["-o", output_module_file.path])
    args.add("--")
    args.add_all(ctx.files.srcs)

    ctx.actions.run(
        outputs = [output_module_file],
        inputs = ctx.files.srcs,
        executable = ctx.executable._slangc,
        arguments = [args],
        mnemonic = "SlangCompile",
        progress_message = "Compiling shader module %{output}",
    )

def link_shader(ctx, module_files, output_shader_file, slangc):
    args = ctx.actions.args()
    args.add_all([
        "-target", "spirv",
        "-profile", "spirv_1_6",
        "-o", output_shader_file.path,
        "--",
    ] + module_files)

    ctx.actions.run(
        outputs = [output_shader_file],
        inputs = module_files,
        executable = ctx.executable._slangc,
        arguments = [args],
        mnemonic = "SlangLink",
        progress_message = "Linking shader %{output}",
    )

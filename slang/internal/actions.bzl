def compile_module(ctx, srcs, deps_module_files_depset, output_module_file, slangc, other_modules = []):
    args = ctx.actions.args()
    args.add_all([
        "-I", ctx.bin_dir.path,
        "-o", output_module_file.path,
    ])
    args.add("--")
    args.add_all(ctx.files.srcs)

    inputs = depset(direct = ctx.files.srcs, transitive = [deps_module_files_depset])

    ctx.actions.run(
        outputs = [output_module_file],
        inputs = inputs,
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
        "-I", ctx.bin_dir.path,
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

def compile_module(ctx, srcs, deps_module_files_depset, deps_root_paths_depset, output_module_file):
    slangc = ctx.toolchains["//slang:toolchain_type"].slangc

    args = ctx.actions.args()
    args.add_all(deps_root_paths_depset.to_list(), before_each = "-I")
    args.add_all([
        "-o",
        output_module_file.path,
    ])
    args.add("--")
    args.add_all(ctx.files.srcs)

    inputs = depset(direct = ctx.files.srcs, transitive = [deps_module_files_depset])

    ctx.actions.run(
        outputs = [output_module_file],
        inputs = inputs,
        executable = slangc,
        arguments = [args],
        mnemonic = "SlangCompile",
        progress_message = "Compiling shader module %{output}",
    )

def link_shader(ctx, module_files, output_shader_file):
    slangc = ctx.toolchains["//slang:toolchain_type"].slangc

    args = ctx.actions.args()
    args.add_all(module_files)
    args.add_all([
        "-target",
        "spirv",
        "-profile",
        "spirv_1_6",
        "-o",
        output_shader_file.path,
    ])

    ctx.actions.run(
        outputs = [output_shader_file],
        inputs = module_files,
        executable = slangc,
        arguments = [args],
        mnemonic = "SlangLink",
        progress_message = "Linking shader %{output}",
    )

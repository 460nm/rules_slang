_OS_CONSTRAINTS = {
    "windows": "@platforms//os:windows",
    "linux": "@platforms//os:linux",
}

_ARCH_CONSTRAINTS = {
    "x86_64": "@platforms//cpu:x86_64",
}

_BUILD_FILE_HEADER = """
load("@rules_slang//slang/internal:toolchain.bzl", "slang_toolchain")
"""

_BUILD_FILE_TOOLCHAIN = """
slang_toolchain(
    name = "slang_toolchain_%{os}_%{arch}",
    slangc = "@%{repo}//:slangc",
)

toolchain(
    name = "toolchain_%{os}_%{arch}",
    exec_compatible_with = [
        "%{os_constraint}",
        "%{arch_constraint}",
    ],
    toolchain_type = "@rules_slang//slang:toolchain_type",
    toolchain = ":slang_toolchain_%{os}_%{arch}",
    visibility = ["//visibility:public"],
)
"""

def _slang_toolchains_impl(ctx):
    if len(ctx.attr.repos) != len(ctx.attr.os_arch):
        fail("repos and os_arch attributes must have the same length")

    build_file_content = _BUILD_FILE_HEADER

    for i, repo in enumerate(ctx.attr.repos):
        os_arch = ctx.attr.os_arch[i]
        os, arch = os_arch.split(":")

        build_file_content += _BUILD_FILE_TOOLCHAIN \
            .replace("%{repo}", repo) \
            .replace("%{os}", os) \
            .replace("%{arch}", arch) \
            .replace("%{os_constraint}", _OS_CONSTRAINTS[os]) \
            .replace("%{arch_constraint}", _ARCH_CONSTRAINTS[arch])

    ctx.file("BUILD.bazel", build_file_content)

slang_toolchains = repository_rule(
    implementation = _slang_toolchains_impl,
    attrs = {
        "repos": attr.string_list(mandatory = True),
        "os_arch": attr.string_list(
            mandatory = True,
            doc = "One per repo, as 'os:arch', e.g. 'windows:x86_64'",
        ),
    },
)

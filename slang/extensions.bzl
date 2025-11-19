load("//slang/internal:distribs.bzl", "DISTRIBS")
load("//slang/internal:slang_download.bzl", "slang_download")
load("//slang/internal:toolchains.bzl", "slang_toolchains")

def _slang_impl(ctx):
    version = "2025.22.1"

    if not version in DISTRIBS:
        fail("unsupported Slang version: {}".format(version))

    distribs = DISTRIBS[version]

    repos = []
    os_archs = []

    for distrib in distribs:
        repo_name = "slang_distrib_{}_{}".format(distrib["os"], distrib["arch"])

        slang_download(
            name = repo_name,
            urls = [distrib["url"]],
            sha256 = distrib["sha256"],
            os = distrib["os"],
        )

        repos.append(repo_name)
        os_archs.append("{}:{}".format(distrib["os"], distrib["arch"]))

    slang_toolchains(
        name = "slang_toolchains",
        repos = repos,
        os_arch = os_archs,
    )

slang = module_extension(
    implementation = _slang_impl,
    os_dependent = False,
    arch_dependent = False,
)

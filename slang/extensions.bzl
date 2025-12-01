load("//slang/internal:distribs.bzl", "DISTRIBS", "parse_version")
load("//slang/internal:slang_download.bzl", "slang_download")
load("//slang/internal:toolchains.bzl", "slang_toolchains")

_version_tag = tag_class(
    attrs = {
        "version": attr.string(mandatory = True),
    },
)

def _slang_impl(ctx):
    max_version_num = -1
    version = None

    for module in ctx.modules:
        for tag in module.tags.version:
            if not tag.version in DISTRIBS:
                fail("unsupported Slang version: {}".format(tag.version))

            version_num = parse_version(tag.version)
            if version_num > max_version_num:
                max_version_num = version_num
                version = tag.version

    if version == None:
        for version_candidate in DISTRIBS.keys():
            version_candidate_num = parse_version(version_candidate)
            if version_candidate_num > max_version_num:
                max_version_num = version_candidate_num
                version = version_candidate

    if version == None:
        fail("no Slang version specified and no default version available")

    repos = []
    os_archs = []
    distribs = DISTRIBS[version]

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
    tag_classes = {
        "version": _version_tag,
    },
    os_dependent = False,
    arch_dependent = False,
)

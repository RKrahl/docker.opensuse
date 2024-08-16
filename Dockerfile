FROM registry.opensuse.org/opensuse/tumbleweed

# Do some sanitization to the library image:
# * We don't want any non-oss packages in the image, so disable this
#   repo right away.
# * Disable auto-refresh on remaining repositories, only refresh them
#   once at image build time.
# * Apply patches.
# * Add a few very basic packages needed by most derived images.
# * Add the init script.

RUN zypper --non-interactive modifyrepo \
	--disable repo-non-oss && \
    zypper --non-interactive modifyrepo --no-refresh \
	repo-openh264 \
	repo-oss \
	repo-update && \
    zypper --non-interactive refresh && \
    ( zypper --non-interactive patch || \
        ((test $? == 103) && zypper --non-interactive patch )) && \
    zypper --non-interactive install \
	curl \
	file \
	glibc-locale \
	pwgen \
	timezone \
	which

RUN zypper --non-interactive addrepo https://download.opensuse.org/repositories/home:/Rotkraut:/Docker/openSUSE_Tumbleweed/home:Rotkraut:Docker.repo && \
    zypper --non-interactive --gpg-auto-import-keys refresh home_Rotkraut_Docker && \
    zypper --non-interactive install tiny-init && \
    zypper --non-interactive modifyrepo --disable home_Rotkraut_Docker

ENTRYPOINT ["/usr/sbin/tiny-init"]

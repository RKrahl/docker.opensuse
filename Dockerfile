FROM registry.opensuse.org/opensuse/leap:15.5

# Do some sanitization to the library image:
# * We don't want any non-oss packages in the image, so disable this
#   repo right away.
# * Disable auto-refresh on remaining repositories, only refresh them
#   once at image build time.
# * Apply patches.
# * Add a few very basic packages needed by most derived images.
# * Add the init script.

RUN zypper --non-interactive modifyrepo \
	--disable repo-non-oss repo-update-non-oss && \
    zypper --non-interactive modifyrepo --no-refresh \
	repo-backports-update \
	repo-openh264 \
	repo-oss \
	repo-sle-update \
	repo-update && \
    zypper --non-interactive refresh && \
    zypper --non-interactive addlock python3-base && \
    ( zypper --non-interactive patch || \
        ((test $? == 103) && zypper --non-interactive patch )) && \
    zypper --non-interactive install \
	curl \
	file \
	glibc-locale \
	pwgen \
	python311-base \
	timezone \
	update-alternatives \
	which && \
    update-alternatives --install \
	/usr/bin/python3 python3 /usr/bin/python3.11 311

RUN zypper --non-interactive addrepo https://download.opensuse.org/repositories/home:/Rotkraut:/python-extra/15.5/home:Rotkraut:python-extra.repo && \
    zypper --non-interactive addrepo https://download.opensuse.org/repositories/home:/Rotkraut:/Docker/15.5/home:Rotkraut:Docker.repo && \
    zypper --non-interactive --gpg-auto-import-keys refresh home_Rotkraut_python-extra home_Rotkraut_Docker && \
    zypper --non-interactive install tiny-init && \
    zypper --non-interactive modifyrepo --disable home_Rotkraut_Docker

ENTRYPOINT ["/usr/sbin/tiny-init"]

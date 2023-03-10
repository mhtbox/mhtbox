################################################################################
#
# sysklogd
#
################################################################################

SYSKLOGD_VERSION = 1.6
SYSKLOGD_SITE = $(call github,troglobit,sysklogd,v$(SYSKLOGD_VERSION))
SYSKLOGD_LICENSE = GPL-2.0+
SYSKLOGD_LICENSE_FILES = COPYING
# From git
SYSKLOGD_AUTORECONF = YES
# install binaries to /sbin
SYSKLOGD_CONF_OPTS = --exec-prefix=/

define SYSKLOGD_INSTALL_SAMPLE_CONFIG
	$(INSTALL) -D -m 0644 package/sysklogd/syslog.conf \
		$(TARGET_DIR)/etc/syslog.conf
endef

SYSKLOGD_POST_INSTALL_TARGET_HOOKS += SYSKLOGD_INSTALL_SAMPLE_CONFIG

define SYSKLOGD_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/sysklogd/S01syslogd \
		$(TARGET_DIR)/etc/init.d/S01syslogd
	$(INSTALL) -m 755 -D package/sysklogd/S02klogd \
		$(TARGET_DIR)/etc/init.d/S02klogd
endef

define SYSKLOGD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(SYSKLOGD_PKGDIR)/syslogd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/syslogd.service
	$(INSTALL) -D -m 644 $(SYSKLOGD_PKGDIR)/klogd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/klogd.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/syslogd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/syslogd.service
	ln -sf ../../../usr/lib/systemd/system/syslogd.service \
		$(TARGET_DIR)/etc/systemd/system/syslog.service
endef

$(eval $(autotools-package))

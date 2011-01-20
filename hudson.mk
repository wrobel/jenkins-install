URL_WAR=http://updates.hudson-labs.org/download/war/1.392/hudson.war
PLUGINS=analysis-collector.hpi.1.8 \
        analysis-core.hpi.1.14 \
        checkstyle.hpi.3.10 \
        clover.hpi.3.0.2 \
        dashboard-view.hpi.1.8.1 \
        dry.hpi.2.10 \
        git.hpi.1.1.3 \
        greenballs.hpi.1.8 \
        htmlpublisher.hpi.0.4 \
        jdepend.hpi.1.2.2 \
        pmd.hpi.3.10 \
        violations.hpi.0.7.7 \
        xunit.hpi.1.12

URL_WAR_LATEST=http://hudson-ci.org/latest/hudson.war
PLUGINS_LATEST=analysis-collector.hpi \
               analysis-core.hpi \
               checkstyle.hpi \
               clover.hpi \
               dashboard-view.hpi \
               dry.hpi \
               git.hpi \
               greenballs.hpi \
               htmlpublisher.hpi \
               jdepend.hpi \
               pmd.hpi \
               violations.hpi \
               xunit.hpi

.PHONY:hudson-install
hudson-install: hudson-war hudson-plugins

.PHONY:hudson-war
hudson-war: $(INSTALLDIR)/war/hudson.war

$(INSTALLDIR)/war/hudson.war: $(INSTALLDIR)/war/.keep
	cd $(INSTALLDIR)/war && wget $(URL_WAR)

$(INSTALLDIR)/war/.keep:
	mkdir -p $(INSTALLDIR)/war
	touch $@

.PHONY:hudson-plugins
hudson-plugins: $(WORKDIR)/workdir/plugins/.keep $(PLUGINS)

$(WORKDIR)/workdir/plugins/.keep:
	mkdir -p $(WORKDIR)/workdir/plugins
	touch $@

PHONY: $(PLUGINS)
$(PLUGINS): $(WORKDIR)/workdir/plugins/.keep
	NAME=$(shell echo $(@) | sed -e 's/\.hpi\..*//'); \
	  VERSION=$(shell echo $(@) | sed -e 's/.*\.hpi\.//'); \
	  cd $(WORKDIR)/workdir/plugins && wget http://hudson-ci.org/download/plugins/$$NAME/$$VERSION/$$NAME.hpi

.PHONY:hudson-install-latest
hudson-install-latest: hudson-war-latest hudson-plugins-latest

PHONY:hudson-war-latest
hudson-war-latest: $(INSTALLDIR)/war/.keep
	cd $(INSTALLDIR)/war && wget $(URL_WAR_LATEST)

PHONY: hudson-plugins-latest
hudson-plugins-latest: $(PLUGINS_LATEST)

PHONY:$(PLUGINS_LATEST)
$(PLUGINS_LATEST): $(WORKDIR)/workdir/plugins/.keep
	cd $(WORKDIR)/workdir/plugins && wget http://hudson-ci.org/latest/$(@)

.PHONY:start
start:
	export INSTALLDIR=$(INSTALLDIR) WORKDIR=$(WORKDIR) && \
	  $(INSTALLDIR)/init.d/hudson start

.PHONY:stop
stop:
	export INSTALLDIR=$(INSTALLDIR) WORKDIR=$(WORKDIR) && \
	  $(INSTALLDIR)/init.d/hudson stop

PHONY:hudson-clean
hudson-clean:
	rm -rf $(INSTALLDIR)/log/hudson.log \
	       $(INSTALLDIR)/run/hudson.pid \
	       $(INSTALLDIR)/run/hudson     \
	       $(INSTALLDIR)/war/hudson.war \
	       $(INSTALLDIR)/war/hudson.tmp \
	       $(INSTALLDIR)/war/hudson.bak \
	       $(WORKDIR)/workdir/plugins

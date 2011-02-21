WAR_URL=http://updates.jenkins-labs.org/download/war/1.395/jenkins.war
PLUGIN_URL=http://updates.jenkins-labs.org/download/plugins/

PLUGINS=analysis-collector.hpi.1.9 \
        analysis-core.hpi.1.15 \
        checkstyle.hpi.3.11 \
        clover.hpi.3.0.2 \
        dashboard-view.hpi.1.8.2 \
        dry.hpi.2.11 \
        git.hpi.1.1.4 \
        greenballs.hpi.1.9 \
        htmlpublisher.hpi.0.6 \
        jdepend.hpi.1.2.2 \
        pmd.hpi.3.11 \
        violations.hpi.0.7.7 \
        xunit.hpi.1.13

WAR_LATEST_URL=http://updates.jenkins-labs.org/latest/jenkins.war
PLUGIN_LATEST_URL=http://updates.jenkins-labs.org/latest/

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

.PHONY:jenkins-install
jenkins-install: jenkins-war jenkins-plugins

.PHONY:jenkins-war
jenkins-war: $(INSTALLDIR)/war/jenkins.war

$(INSTALLDIR)/war/jenkins.war: $(INSTALLDIR)/war/.keep
	cd $(INSTALLDIR)/war && wget $(WAR_URL)

$(INSTALLDIR)/war/.keep:
	mkdir -p $(INSTALLDIR)/war
	touch $@

.PHONY:jenkins-plugins
jenkins-plugins: $(WORKDIR)/workdir/plugins/.keep $(PLUGINS)

$(WORKDIR)/workdir/plugins/.keep:
	mkdir -p $(WORKDIR)/workdir/plugins
	touch $@

PHONY: $(PLUGINS)
$(PLUGINS): $(WORKDIR)/workdir/plugins/.keep
	NAME=$(shell echo $(@) | sed -e 's/\.hpi\..*//'); \
	  VERSION=$(shell echo $(@) | sed -e 's/.*\.hpi\.//'); \
	  cd $(WORKDIR)/workdir/plugins && wget $(PLUGIN_URL)/$$NAME/$$VERSION/$$NAME.hpi

.PHONY:jenkins-install-latest
jenkins-install-latest: jenkins-war-latest jenkins-plugins-latest

PHONY:jenkins-war-latest
jenkins-war-latest: $(INSTALLDIR)/war/.keep
	cd $(INSTALLDIR)/war && wget $(WAR_LATEST_URL)

PHONY: jenkins-plugins-latest
jenkins-plugins-latest: $(PLUGINS_LATEST)

PHONY:$(PLUGINS_LATEST)
$(PLUGINS_LATEST): $(WORKDIR)/workdir/plugins/.keep
	cd $(WORKDIR)/workdir/plugins && wget $(PLUGIN_LATEST_URL)/$(@)

.PHONY:start
start:
	export INSTALLDIR=$(INSTALLDIR) WORKDIR=$(WORKDIR) && \
	  $(INSTALLDIR)/init.d/jenkins start

.PHONY:stop
stop:
	export INSTALLDIR=$(INSTALLDIR) WORKDIR=$(WORKDIR) && \
	  $(INSTALLDIR)/init.d/jenkins stop

PHONY:jenkins-clean
jenkins-clean:
	rm -rf $(INSTALLDIR)/log/jenkins.log \
	       $(INSTALLDIR)/run/jenkins.pid \
	       $(INSTALLDIR)/run/jenkins     \
	       $(INSTALLDIR)/war            \
	       $(WORKDIR)/workdir/plugins

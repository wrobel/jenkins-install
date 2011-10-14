WAR_URL=http://mirrors.jenkins-ci.org/war/1.434/jenkins.war
PLUGIN_URL=http://mirrors.jenkins-ci.org/plugins/

PLUGINS=analysis-collector.hpi.1.17 \
        analysis-core.hpi.1.30 \
        checkstyle.hpi.3.20 \
        cloverphp.hpi.0.3.1 \
        dashboard-view.hpi.2.1 \
        dry.hpi.2.20 \
        git.hpi.1.1.12 \
        greenballs.hpi.1.11 \
        htmlpublisher.hpi.0.7 \
        jdepend.hpi.1.2.3 \
        plot.hpi.1.5 \
        pmd.hpi.3.21 \
        violations.hpi.0.7.10 \
        xunit.hpi.1.23

WAR_LATEST_URL=http://mirrors.jenkins-ci.org/war/latest/jenkins.war
# No provided at the moment
PLUGIN_LATEST_URL=http://mirrors.jenkins-ci.org/latest/

PLUGINS_LATEST=analysis-collector.hpi \
               analysis-core.hpi \
               checkstyle.hpi \
               cloverphp.hpi \
               dashboard-view.hpi \
               dry.hpi \
               git.hpi \
               greenballs.hpi \
               htmlpublisher.hpi \
               jdepend.hpi \
               plot.hpi \
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

# Should be:
#jenkins-install-latest: jenkins-war-latest jenkins-plugins-latest
# But "latest" plugins are currently not being provided.
.PHONY:jenkins-install-latest
jenkins-install-latest: jenkins-war-latest jenkins-plugins

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

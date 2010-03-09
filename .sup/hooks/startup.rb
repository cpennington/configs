class Filter

    def & (o)
        And.new(self, o)
    end

    def | (o)
        Or.new(self, o)
    end

end

class And < Filter
    def initialize(left, right)
        @left = left
        @right = right
    end

    def matches(message)
        @left.matches(message) && @right.matches(message)
    end
end

class Or < Filter
    def initialize(left, right)
        @left = left
        @right = right
    end

    def matches(message)
        @left.matches(message) || @right.matches(message)
    end
end

class Subject < Filter
    def initialize(regex)
        @regex = regex
    end

    def matches(message)
        message.subj =~ @regex
    end
end

class To < Filter
    def initialize(regex)
        @regex = regex
    end

    def matches(message)
        message.recipients.any? do |recipient|
            recipient.email =~ @regex
        end
    end
end

class From < Filter
    def initialize(regex)
        @regex = regex
    end

    def matches(message)
        message.from.full_address =~ @regex
    end
end

class Label < Filter
    def initialize(label)
        @label = label.to_sym
    end

    def matches(message)
        message.has_label? @label
    end
end

class Body < Filter
    def initialize(regex)
        @regex = regex
    end

    def matches(message)
        message.body =~ regex
    end
end

def subject(regex)
    Subject.new(regex)
end

def to(regex)
    To.new(regex)
end

def from(regex)
    From.new(regex)
end

def label(regex)
    Label.new(regex)
end

def body(regex)
    Body.new(regex)
end

LABELINGS = {
    subject(/ggate-monitor/) => [:golden_gate],
    subject(/FogBugz \(Case .*\)/) => [:fogbugz],
    subject(/\[DMSERVER\]/) => [:sync, :dmserver],
    from(/noreply.hudson/) => [:mclass, :hudson],
    subject(/build failed/i) => [:failed_build],
    subject(/SCOOP/) | subject(/POOCS/) | to(/WGen-SCOOP/) => [:scoop],
    subject(/Your Yammer activity/) | subject(/\[Yammer: wgen.net network\]/) => [:yammer],
    from(/syncserver/) => [:sync],
    from(/camserver/) => [:cam, :sync],
    from(/@.*dog\d+\.wgen\.net/) => [:prod, :old_environment],
    from(/rod.wgenhq.net/) | from(/todd.wgenhq.net/) => [:dev, :old_environment],
    subject(/\[.*\] low space:/) => [:low_space],
    subject(/\[ERROR\] Failed Sync/) => [:failed_sync],
    from(/syncdog/) => [:sync],
    from(/nagios/) => [:nagios],
    from(/doe.*\.arisdc\.net/) => [:aris, :prod],
    from(/mc\.wgenhq\.net/) => [:mclass, :new_environment],
    subject(/cron/i) => [:cron],
    subject(/logwatch/) => [:logwatch],
    subject(/fed.ex/i) => [:fedex],
    from(/CruiseControl/) => [:cruisecontrol],
    from(/aris-hudson/) => [:aris, :hudson],
    from(/badqueries-prod@wgen\.net/) => [:bad_queries, :prod],
    subject(/fixNullORFGroups/) => [:fix_null_orf_groups],
    from(/syncdatamart/) => [:sync_data_mart],
    from(/Web TimeSheet/) => [:timesheet],
    from(/reallycandid/) => [:rc],
    subject(/\[sync-build\]/) => [:sync, :build],
    from(/Sawmill Runtime User/) => [:sawmill],
    subject(/Logwatch/) => [:logwatch],
    subject(/LSB LAG DETECTED/) => [:lsb_lag],
    subject(/Sync status report/) => [:sync, :sync_status_report],
    subject(/tunnel to prod acting up, check monit/) => [:prod, :monit, :prod_tunnel],
    to(/user@sonar.codehaus.org/) => [:sonar_user],
#    body(/Microsoft Outlook Web Access/) => [:meeting],
}

ARCHIVE = [
    label(:sync) & (subject(/Failed Sync/) | subject(/session crash report/) | subject(/CAM Server no current staff/)),
    label(:golden_gate),
    label(:fedex),
    label(:dmserver) & subject(/session crash report/),
    label(:sawmill),
    label(:fix_null_orf_groups),
    label(:bad_queries),
    label(:yammer),
    label(:prod) & label(:monit),
    label(:lsb_lag),
]

require 'ldap'

CONTACT_TYPES = {
    'OU=Users,OU=Corporate,DC=wgenhq,DC=net' => '(objectclass=user)',
    'OU=Distribution Groups,OU=Corporate,DC=wgenhq,DC=net' => '(objectclass=group)',
    'OU=Security Groups,OU=Corporate,DC=wgenhq,DC=net' => '(objectclass=group)',
    'OU=Service Accounts,OU=Corporate,DC=wgenhq,DC=net' => '(objectclass=*)',
}
def load_contacts()
    contacts = []

    conn = LDAP::Conn.open('wgldap.wgenhq.net', 3268)
    conn.bind('WGENHQ\cpennington', File.new(File.expand_path('~/.pwd')).read().strip()) do |conn|
        CONTACT_TYPES.each_pair do |base_dn, search_type|
            conn.search(base_dn, LDAP::LDAP_SCOPE_SUBTREE, search_type, ['mail', 'displayName']) do |entry|
                if entry['mail']
                    entry['mail'].each do |address|
                        if entry['displayName']
                            entry['displayName'].each do |name|
                                contacts << "%s <%s>" % [name, address]
                            end
                        else
                            contacts << address
                        end
                    end
                end
            end
        end
    end
    contacts
end

CONTACTS = load_contacts()

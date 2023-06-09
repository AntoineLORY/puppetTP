class base {
    class { 'firewall': }
    Firewall {
        require => undef,
    }

    # Default firewall rules
    firewall { '000 accept all icmp':
        proto  => 'icmp',
        action => 'accept',
    }
    -> firewall { '001 accept all to lo interface':
        proto   => 'all',
        iniface => 'lo',
        action  => 'accept',
    }
    -> firewall { '002 reject local traffic not on loopback interface':
        iniface     => '! lo',
        proto       => 'all',
        destination => '127.0.0.1/8',
        action      => 'reject',
    }
    -> firewall { '003 accept related established rules':
        proto  => 'all',
        state  => ['RELATED', 'ESTABLISHED'],
        action => 'accept',
    }
    -> firewall { '100 allow http and https access':
        dport  => [80, 443],
        proto  => 'tcp',
        action => 'accept',
    }
    -> firewall { '101 allow ssh access':
        dport  => 22,
        proto  => 'tcp',
        action => 'accept',
    }
    -> firewall { '999 drop all':
        proto  => 'all',
        action => 'drop',
        before => undef,
    }
    class { 'apache': }
    
}
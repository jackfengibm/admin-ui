require 'logger'
require_relative '../spec_helper'
require 'cron_parser'

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => ['0 * * * *'],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'runs once an hour at the beginning of the hour' do
      time_last_run = Time.now
      stats_schedules = ['0 * * * *']
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        current_time = Time.now.to_i
        refresh_time = cron_parser.next(time_last_run).to_i
        sec_to_next_run = refresh_time - current_time
        expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
      end
    end
  end
end

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => ['0  0 * * *'],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'run once a day at midnight 12:00AM' do
      time_last_run = Time.now
      stats_schedules = ['0 0 * * *']
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        current_time = Time.now.to_i
        refresh_time = cron_parser.next(stats.time_last_run).to_i
        sec_to_next_run = refresh_time - current_time
        expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
      end
    end
  end
end

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => ['0 0 * * 0'],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'run once a week at midnight 12:00AM of every Sunday' do
      time_last_run = Time.now
      stats_schedules = ['0 0 * * 0']
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        current_time = Time.now.to_i
        refresh_time = cron_parser.next(stats.time_last_run).to_i
        sec_to_next_run = refresh_time - current_time
        expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
      end
    end
  end
end

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => ['0 0 1 * *'],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'run once a month at midnight 12:00AM of every first day of the month' do
      time_last_run = Time.now
      stats_schedules = ['0 0 1 * *']
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        current_time = Time.now.to_i
        refresh_time = cron_parser.next(stats.time_last_run).to_i
        sec_to_next_run = refresh_time - current_time
        expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
      end
    end
  end
end

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => ['0 0 1 1 *'],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'runs once a year at midnight 12:00AM of every January 1st' do
      time_last_run = Time.now
      stats_schedules = ['0 0 1 1 *']
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        current_time = Time.now.to_i
        refresh_time = cron_parser.next(time_last_run).to_i
        sec_to_next_run = refresh_time - current_time
        expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
      end
    end
  end
end

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => ['@hourly'],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'runs once an hour at the beginning of the hour using predefined schedule' do
      time_last_run = Time.now
      stats_schedules = ['@hourly']
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        current_time = Time.now.to_i
        refresh_time = cron_parser.next(time_last_run).to_i
        sec_to_next_run = refresh_time - current_time
        expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
      end
    end
  end
end

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => ['@daily'],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'run once a day at midnight 12:00AM using predefined schedule' do
      time_last_run = Time.now
      stats_schedules = ['@daily']
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        current_time = Time.now.to_i
        refresh_time = cron_parser.next(stats.time_last_run).to_i
        sec_to_next_run = refresh_time - current_time
        expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
      end
    end
  end
end

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => ['@weekly'],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'run once a week at midnight 12:00AM of every Sunday using predefined schedule' do
      time_last_run = Time.now
      stats_schedules = ['@weekly']
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        current_time = Time.now.to_i
        refresh_time = cron_parser.next(stats.time_last_run).to_i
        sec_to_next_run = refresh_time - current_time
        expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
      end
    end
  end
end

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => ['@monthly'],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'run once a month at midnight 12:00AM of every first day of the month using predefined schedule' do
      time_last_run = Time.now
      stats_schedules = ['@monthly']
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        current_time = Time.now.to_i
        refresh_time = cron_parser.next(stats.time_last_run).to_i
        sec_to_next_run = refresh_time - current_time
        expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
      end
    end
  end
end

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => ['@yearly'],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'runs once a year at midnight 12:00AM of every January 1st using predefined schedule - @yearly' do
      time_last_run = Time.now
      stats_schedules = ['@yearly']
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        current_time = Time.now.to_i
        refresh_time = cron_parser.next(time_last_run).to_i
        sec_to_next_run = refresh_time - current_time
        expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
      end
    end
  end
end

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => ['@annually'],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'runs once a year at midnight 12:00AM of every January 1st using predefined schedule - @annually' do
      time_last_run = Time.now
      stats_schedules = ['@annually']
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        current_time = Time.now.to_i
        refresh_time = cron_parser.next(time_last_run).to_i
        sec_to_next_run = refresh_time - current_time
        expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
      end
    end
  end
end

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => [ '0 1 * * *', '0 12-17 * * 1-5' ],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'runs once at 1:00 AM every day and at 12:00PM, 1:00PM, 2:00PM, 3:00PM, 4:00PM, 5:00PM, 8:00PM Monday to Friday - range' do
      time_last_run = Time.now
      target_time = time_last_run
      stats_schedules = [ '0 1 * * *', '0 12-17 * * 1-5' ]
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        refresh_time = cron_parser.next(time_last_run).to_i
        if (target_time == time_last_run || target_time > refresh_time)
          target_time = refresh_time
        end
      end
      sec_to_next_run = target_time - time_last_run.to_i
      expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
    end
  end
end

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => [ '0 1 * * *', '0 0 12,13,14,15,16,17,20 * * 1-5' ],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'runs once at 1:00 AM every day and at 12:00PM, 1:00PM, 2:00PM, 3:00PM, 4:00PM, 5:00PM, 8:00PM Monday to Friday - sequence without steps' do
      time_last_run = Time.now
      target_time = time_last_run
      stats_schedules = [ '0 1 * * *', '0 0 12,13,14,15,16,17,20 * * 1-5' ]
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        refresh_time = cron_parser.next(time_last_run).to_i
        if (target_time == time_last_run || target_time > refresh_time)
          target_time = refresh_time
        end
      end
      sec_to_next_run = target_time - time_last_run.to_i
      expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
    end
  end
end

describe AdminUI::Stats do
  let(:data_file) { '/tmp/admin_ui_data.json' }
  let(:log_file) { '/tmp/admin_ui.log' }
  let(:logger) { Logger.new(log_file) }
  let(:config) do
    AdminUI::Config.load(:stats_refresh_schedules      => [ '0 1 * * *', '0 0 12,13,15-17,20 * * 1-5' ],
                         :data_file                    => data_file,
                         :mbus                         => 'nats://nats:c1oudc0w@localhost:14222',
                         :monitored_components         => [],
                         :nats_discovery_timeout       => 1)
  end
  let(:email) { AdminUI::EMail.new(config, logger) }
  let(:nats) { AdminUI::NATS.new(config, logger, email) }
  let(:varz) { AdminUI::VARZ.new(config, logger, nats) }
  let(:client) { AdminUI::CCRestClient.new(config, logger) }
  let(:cc) { AdminUI::CC.new(config, logger, client) }
  let(:stats){ AdminUI::Stats.new(config, logger, cc, varz)}

  before do
    AdminUI::Config.any_instance.stub(:validate)
  end

  context 'calculate_time_until_generate_stats' do
    it 'runs once at 1:00 AM every day and at 12:00PM, 1:00PM, 2:00PM, 3:00PM, 4:00PM, 5:00PM, 8:00PM Monday to Friday - mix use of range and sequence without step' do
      time_last_run = Time.now
      target_time = time_last_run
      stats_schedules = [ '0 1 * * *', '0 0 12,13,15-17,20 * * 1-5' ]
      stats_schedules.each do |spec|
        cron_parser = CronParser.new(spec)
        refresh_time = cron_parser.next(time_last_run).to_i
        if (target_time == time_last_run || target_time > refresh_time)
          target_time = refresh_time
        end
      end
      sec_to_next_run = target_time - time_last_run.to_i
      expect(stats.calculate_time_until_generate_stats).to eq(sec_to_next_run)
    end
  end
end
# frozen_string_literal: true

module GitScripts
  class Environment
    class << self
      VERSION_REGEX = /^(\d+\.\d+\.\d+).*/

      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/AbcSize
      def latest_environment_version(name)
        username_key = "AEM_#{name.upcase}_USERNAME"
        password_key = "AEM_#{name.upcase}_PASSWORD"
        username = ENV[username_key]
        password = ENV[password_key]
        credentials = Base64.encode64("#{username}:#{password}").gsub("\n", '')

        begin
          env_id = resolve_environment_id(name)
          raise "Unknown or unsupported AEM_ENVIRONMENT: #{name}" if env_id.nil?

          origin = "https://author-p163316-e#{env_id}.adobeaemcloud.com"
          url = "#{origin}/crx/packmgr/service.jsp?cmd=ls"
          headers = {
            'Authorization' => "Basic #{credentials}"
          }

          if username.to_s.strip.empty? || password.to_s.strip.empty?
            raise "Missing AEM credentials: please set the '#{username_key}' and " \
              "'#{password_key}' environment variables"
          end

          response = RestClient.get url, headers

          xml = Nokogiri.XML(response.body)
          tr_all_packages = xml
            .xpath('//packages/package')
            .select do |pkg|
              name = pkg.at_xpath('name')&.text.to_s
              group = pkg.at_xpath('group')&.text.to_s
              name == 'tr.all' && group == 'com.tr'
            end

          valid_tr_all_packages = tr_all_packages
            .reject { |item| item.at_xpath('lastUnpacked')&.text.to_s.blank? }

          if valid_tr_all_packages.empty?
            raise "No valid 'tr.all' packages with 'lastUnpacked' found on #{origin} " \
              "(found #{tr_all_packages.size} entries)"
          end

          latest_package = valid_tr_all_packages.max_by do |item|
            text = item.at_xpath('lastUnpacked')&.text.to_s

            begin
              Time.strptime(text, '%a, %d %b %Y %H:%M:%S %z')
            rescue ArgumentError
              Time.at(0)
            end
          end

          raise 'Unable to determine the latest package from available entries' unless latest_package

          version_node_text = latest_package.at_xpath('version')&.text.to_s
          raise 'Latest package has no version node' if version_node_text.to_s.strip.empty?

          VERSION_REGEX.match(version_node_text)[1]
        rescue StandardError => e
          puts "Failed to retrieve the latest environment version for #{name}"
          puts e

          exit 1
        end
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/PerceivedComplexity

      def resolve_environment_id(aem_environment)
        mapping = {
          'dev' => '1757025',
          'qa' => '1779100',
          'uat' => '1779207',
          'ppe' => '1779165',
          'prod' => '1779099'
        }

        mapping[aem_environment.to_s.downcase]
      end
    end
  end
end

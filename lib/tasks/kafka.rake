namespace :kafka do
  desc "Run the Kafka consumer loop"
  task consume: :environment do
    KafkaIntegration::Consumer.new.consume
  end
end

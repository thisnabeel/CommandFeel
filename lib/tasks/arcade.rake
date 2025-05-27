namespace :arcade do
  desc 'Generate new arcade content'
  task generate: :environment do
    begin
      job_status = JobStatus.create!(
        job_type: 'arcade_generation',
        status: 'running',
        started_at: Time.current
      )

      controller = WondersController.new
      controller.generate_arcade

      job_status.update!(
        status: 'completed',
        completed_at: Time.current
      )
    rescue => e
      job_status.update!(
        status: 'failed',
        error_message: e.message,
        completed_at: Time.current
      )
      Rails.logger.error("Arcade generation failed: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
    end
  end
end 
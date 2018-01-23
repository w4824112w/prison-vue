#encoding = utf-8

require "#{Rails.root}/lib/yunxin"

class DispatchWorker
  include Sidekiq::Worker
  include YunXin

  def perform(*args)
    meeting = Meeting.find_by(id: args[0])

    if meeting 
      if meeting.status == 'PENDING'

        family = meeting.family
        jail = family.prisoner.jail
        terminals_ids = jail.terminals.ids    
        meeting_queue = jail.configuration.settings['meeting_queue']
    
        shortest_terminal_id_and_position(terminals_ids, meeting_queues(meeting, terminals_ids)) do |array|
  
          if array[1] < meeting_queue.size
            meeting_time = "#{meeting.application_date} #{meeting_queue[array[1]]}"
            update_and_send_message(jail.accid, 
                                    meeting, 
                                    { phone: "['#{family.phone}']",
                                      attach: { code: 200, meeting_time: meeting_time, jail: jail.title }
                                    }, 
                                    { terminal_id: array[0], 
                                      meeting_time: meeting_time, 
                                      status: 'PASSED' 
                                    })
            return
          end

          update_and_send_message(jail.accid,
                                  meeting,
                                 { phone: "['#{family.phone}']", 
                                   attach: { code: 400, jail: jail.title, msg: "会见由于当日排满被拒绝。" }
                                 },
                                 { status: 'DENIED' })
          return
        end

      end

      logger.error "meeting ##{args[0]} status is #{meeting.status} cannot update again"
      return
    end

    logger.error "dispatching meeting ##{args[0]} was not found "
  end

  private 

  def update_and_send_message(accid, meeting, msg, attributes)
    if meeting.update_attributes(attributes)
      #logger.info send_sms(6156, msg[:phone], msg[:body])
      logger.info send_message(accid, meeting.family.api_key.access_token, msg[:attach])
      return 
    end
  
    logger.error "update meeting ##{meeting.id} error #{meeting.errors}"  
  end

  def meeting_queues(meeting, terminals_ids)
    Meeting.where(application_date: meeting.application_date, terminal: terminals_ids, status: 'PASSED').
      select(:terminal_id).
      group(:terminal_id).
      count
  end

  def shortest_terminal_id_and_position(ids, queue, &block)
    empty_keys = ids - queue.keys
    if empty_keys.empty?
      yield queue.sort.min_by { |k, v| v }
      return
    end

    yield [empty_keys.first, 0]
  end

  def queue_length(terminal_id, application_date)
    Meeting.where(terminal_id: terminal_id, application_date: application_date, status: 'PASSED').size
  end

end
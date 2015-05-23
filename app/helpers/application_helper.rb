module ApplicationHelper
  def locale_link
    link_to t('sessions.buttons.language'), change_language_path(I18n.locale != :en ? 'en' : 'cs'), class: 'pull-right'
  end

  def flash_alert_class(key)
    alert_class = case key.to_sym
                  when :notice
                    'success'
                  when [:alert, :error]
                    'danger'
                  when :warning
                    'warning'
                  else
                    'primary'
                  end

    "alert-#{alert_class}"
  end

  def flash_icon_class(key)
    icon_class = case key.to_sym
                 when :notice
                   'check'
                 when :warning
                   'warning'
                 when [:error, :alert]
                   'remove'
                 else
                   'info'
                 end

    "fa-#{icon_class}"
  end
end

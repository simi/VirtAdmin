module ApplicationHelper
  def locale_link
    link_to t('sessions.buttons.language'), change_language_path(I18n.locale != :en ? 'en' : 'cs'), class: 'pull-right'
  end

  def flash_display_helper(key)
    case key.to_sym
    when :notice
      { alert_class: 'success', icon_class: 'check' }
    when :warning
      { alert_class: 'warning', icon_class: 'warning' }
    when :error
      { alert_class: 'danger', icon_class: 'remove' }
    when :alert
      { alert_class: 'danger', icon_class: 'remove' }
    else
      { alert_class: 'primary', incon_class: 'info' }
    end
  end
end

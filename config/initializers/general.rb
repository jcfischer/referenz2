#ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:ch_dt] = 

date_formats = { :event => lambda { |date| date.strftime("%B #{date.day.ordinalize}") },
                 :ch_dt => "%d.%m.%Y %H:%M" }


ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.update(date_formats)
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.update(date_formats)

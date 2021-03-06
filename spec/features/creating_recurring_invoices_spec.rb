require 'rails_helper'

feature 'Creating Recurring Invoices' do

  before do
    FactoryGirl.create(:series)
    visit '/recurring_invoices'
  end

  scenario 'can create a recurring invoice', :js => true, driver: :webkit do
    first(:link, 'New Recurring Invoice').click

    expect(page).to have_css('div.row textarea') # empty item available

    select 'Example Series', from: 'recurring_invoice_series_id'

    fill_in 'Starting date', with: '2015-02-28'
    fill_in 'Finishing date', with: '2015-03-01'

    fill_in 'Name', with: 'Test Customer'
    fill_in 'Email', with: 'pepe@abc.com'

    fill_in 'Period', with: 1 # new invoice is active per default

    click_on 'Save'
    expect(page).to have_content('Recurring Invoice was successfully created.')

    invoice = RecurringInvoice.where(name: 'Test Customer').first
    expect(page.current_path).to eql recurring_invoices_path
  end

  scenario 'can not create recurring invoice without customer name', :js => true, driver: :webkit do
    first(:link, 'New Recurring Invoice').click

    click_on 'Save'
    expect(page).to have_content("Recurring Invoice has not been created.")
    expect(page).to have_content("Name can't be blank")
  end



end

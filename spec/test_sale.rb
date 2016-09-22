require_relative 'spec_helper'

require_relative 'spec_helper'

module FarMar
  describe Sale do
    describe '#initialize' do
      it 'Can be created with valid data' do
        Sale.new(4, 30, DateTime.now, 4, 10).id.must_equal 4
      end
    end

    describe 'from_csv' do
      it 'Accepts well-formated CSV lines' do
        good_csv = [
          ['4', '30', DateTime.now.strftime, '4', '10']
        ]
        good_csv.each do |line|
          Sale.from_csv(line)
        end
      end

      it 'Rejects invalid CSV lines' do
        bad_csv = [
          ['non-numeric', '30', DateTime.now.strftime, '4', '10'],
          ['4', 'non-numeric', DateTime.now.strftime, '4', '10'],
          ['4', '30', 'not a date', '4', '10'],
          ['4', '30', DateTime.now.strftime, 'non-numeric', '10'],
          ['4', '30', DateTime.now.strftime, '4', 'non-numeric'],
          ['4', 'not enough fields'],
          ['4', 'this', 'test', 'tests', 'what', 'happens', 'when', 'there', 'are', 'too', 'many', 'fields']
        ]
        bad_csv.each do |line|
          proc { Sale.from_csv(line) }.must_raise ArgumentError, "Did not fail on CSV data #{line}"
        end
      end
    end

    # Because all and find are implemented by and tested through
    # Loadable, they are not tested extensively here.
    describe 'all' do
      before do
        use_production_data
      end

      it 'Can load production data' do
        Sale.all.length.must_be :>, 0
      end
    end

    describe 'between' do
      before do
        use_test_data
      end
    end

    describe '#vendor' do
      before do
        use_test_data
      end

      it 'Returns the vendor associated with this sale' do
        sale = Sale.find(1)
        sale.must_be_instance_of Sale
        vendor = sale.vendor
        vendor.must_be_instance_of Vendor
        vendor.id.must_equal sale.vendor_id
      end

      it 'Returns nil if the vendor associated with this sale D.N.E.' do
        sale = Sale.find(4)
        sale.must_be_instance_of Sale
        sale.vendor.nil?.must_equal true
      end
    end

    describe '#product' do
      before do
        use_test_data
      end

      it 'Returns the product associated with this sale' do
        sale = Sale.find(1)
        sale.must_be_instance_of Sale
        product = sale.product
        product.must_be_instance_of Product
        product.id.must_equal sale.product_id
      end

      it 'Returns nil if the product associated with this sale D.N.E.' do
        sale = Sale.find(5)
        sale.must_be_instance_of Sale
        sale.product.nil?.must_equal true
      end
    end
  end
end

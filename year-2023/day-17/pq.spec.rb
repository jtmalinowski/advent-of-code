require './pq'

RSpec.describe PQ do
  (3..7).to_a.product([true, false]).each do |size, min|
    it "works with all permutations of #{size} as #{min} heap" do
      expected = size.times.to_a
      expected = expected.reverse unless min
  
      expected.permutation.each do |permutation|
        pq = PQ.new min
        permutation.each{|val| pq.insert val}
  
        res = []
        loop do
          break if pq.empty?
          res.push pq.pop
        end
  
        expect(res).to eq(expected)
      end
    end
  end
end

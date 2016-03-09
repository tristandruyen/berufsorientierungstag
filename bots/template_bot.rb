module TemplateBot
  require 'pp'
  def init
    @feld ||= Array.new(20) { Array.new(20) { { in: Set.new, out: Set.new } } }
  end

  def call
    ##################################################
    # EUER CODE HIERHIN
    # l        l      l
    # V        V      V
    pp speicher
    speicher[:in] << richtung
    if speicher[:in].include?((richtung - 90) % 360) &&
       speicher[:out].include?((richtung - 90) % 360) &&
       vor!
      puts 'rechts'
    elsif speicher[:in] != []
      linksgeher
    end
    pp speicher
    speicher[:out] << richtung
    vor!
    # A        A      A
    # l        l      l
    ##################################################
  end

  def linksgeher
    dreh_rechts!
    return nil if vorne_frei?
    dreh_links!
    dreh_links! unless vorne_frei?
  end

  def rechtsgeher
    dreh_links!
    return nil if vorne_frei?
    dreh_rechts!
    dreh_rechts! unless vorne_frei?
  end
end

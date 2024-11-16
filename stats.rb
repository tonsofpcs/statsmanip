#!/usr/bin/env ruby
require 'pp'
require 'nokogiri'
# require 'logger'
require 'net/http'
require 'sinatra'

presetteamname = 'example'
presetsport = 'mbball'
presetxmlfile = '1'

set :port, '8880'
set :bind, '0.0.0.0'

scriptname = "Sports Stats XML Manipulator"
scriptver = "1.1.6"
#1.1.1 add baseball pitcher sorting
#1.1.2 make baseball pitcher selection by pitcher/appear
#1.1.3 add line sums and division
#1.1.4 add basketball team stats fgraw, fg3raw, ftraw concatenations
#1.1.5 add baseball pitcher in-game hits, earned runs
#1.1.6 add xpathsort player catch for invalid unique id, adds random id between 10000 and 99999

get '/stats' do
    sport = params[:sport]
    sport = presetsport if sport.nil?

    teamname = params[:team]
    teamname = presetteamname if teamname.nil?

    xmlfile = params[:xmlfile]
    xmlfile = presetxmlfile if xmlfile.nil?


    content_type 'text/xml'
    # $logger = Logger.new(STDERR)
    # $logger.info "Starting up..."

    xmluri = '/' + teamname + '/' + sport + '/' + xmlfile + '.xml'
    xmlget = Net::HTTP.new('sidearmstats.com').request_get(xmluri)

    #$logger.debug xmlget.body
    abort "GET FAILURE Response" unless xmlget.kind_of? Net::HTTPSuccess

    originals = Array [ "osource","oversion" ]

    doc = Nokogiri::XML(xmlget.body)

    #original uniform[0], remapped uniform[1], player xpath[2],
    #source[3],version[4],base[5]
    uniupdates = Array [
    "uni","unilu","/bbgame/team/player",
    "source","version","/bbgame"
    ]

    uniupdates = Array [
    "uni","unilu","/sogame/team/player",
    "source","version","/sogame"
    ] if sport == 'msoc' || sport == 'wsoc'

    uniupdates = Array [
    "uni","unilu","lcgame/team/player",
    "source","version","/lcgame"
    ] if sport == 'mlax' || sport == 'wlax'

    uniupdates = Array [
    "uni","unilu","bsgame/team/player",
    "source","version","/bsgame"
    ] if sport == 'baseball' || sport == 'softball'

    basepath = doc.root
    basepath.set_attribute(originals[0], basepath.attribute(uniupdates[3]))
    basepath.set_attribute(originals[1], basepath.attribute(uniupdates[4]))
    basepath.set_attribute(uniupdates[3], scriptname)
    basepath.set_attribute(uniupdates[4], scriptver)

    players = doc.xpath(uniupdates[2])

    players.each do |player|
    uni = player.attribute(uniupdates[0]).value
    uni = 90 if uni == '0'
    uni = 99 if uni == '00'
    player.set_attribute(uniupdates[1], uni)
    end

    #[uid, xpath, stats object, stat to sort, output]
    xpathsorts = Array[
        ["personId","/bbgame/team[@vh='H']/player","stats","tp","tp_order"],
        ["personId","/bbgame/team[@vh='V']/player","stats","tp","tp_order"],
        ["personId","/bbgame/team/player","stats","tp","tp_tot_order"],
        ["personId","/bbgame/team[@vh='H']/player","stats","pf","pf_order"],
        ["personId","/bbgame/team[@vh='V']/player","stats","pf","pf_order"],
        ["personId","/bbgame/team/player","stats","pf","pf_tot_order"],
        ["personId","/bbgame/team[@vh='H']/player","stats","treb","treb_order"],
        ["personId","/bbgame/team[@vh='V']/player","stats","treb","treb_order"],
        ["personId","/bbgame/team/player","stats","treb","treb_tot_order"],
        ["personId","/bbgame/team[@vh='H']/player","stats","ast","ast_order"],
        ["personId","/bbgame/team[@vh='V']/player","stats","ast","ast_order"],
        ["personId","/bbgame/team/player","stats","ast","ast_tot_order"],
        ["personId","/bbgame/team[@vh='H']/player","stats","to","to_order"],
        ["personId","/bbgame/team[@vh='V']/player","stats","to","to_order"],
        ["personId","/bbgame/team/player","stats","to","to_tot_order"]
    ]

    xpathsorts = Array[
        ["code","/sogame/team[@vh='H']/player","shots","g","g_order"],
        ["code","/sogame/team[@vh='V']/player","shots","g","g_order"],
        ["code","/sogame/team/player","shots","g","g_tot_order"],
        ["code","/sogame/team[@vh='H']/player","shots","a","a_order"],
        ["code","/sogame/team[@vh='V']/player","shots","a","a_order"],
        ["code","/sogame/team/player","shots","a","a_tot_order"]
    ] if sport == 'msoc' || sport == 'wsoc'

    xpathsorts = Array[
        ["code","/lcgame/team[@vh='H']/player","shots","g","g_order"],
        ["code","/lcgame/team[@vh='V']/player","shots","g","g_order"],
        ["code","/lcgame/team/player","shots","g","g_tot_order"],
        ["code","/lcgame/team[@vh='H']/player","shots","a","a_order"],
        ["code","/lcgame/team[@vh='V']/player","shots","a","a_order"],
        ["code","/lcgame/team/player","shots","a","a_tot_order"],
        ["code","/lcgame/team[@vh='H']/player","misc","gb","gb_order"],
        ["code","/lcgame/team[@vh='V']/player","misc","gb","gb_order"],
        ["code","/lcgame/team/player","misc","gb","gb_tot_order"]
    ] if sport == 'mlax' || sport == 'wlax'

    xpathsorts = Array[
        ["name","/bsgame/team[@vh='H']/player","hitseason","h","s_h_order"],
        ["name","/bsgame/team[@vh='V']/player","hitseason","h","s_h_order"],
        ["name","/bsgame/team/player","hitseason","h","s_h_tot_order"],
        ["name","/bsgame/team[@vh='H']/player","hitseason","r","s_r_order"],
        ["name","/bsgame/team[@vh='V']/player","hitseason","r","s_r_order"],
        ["name","/bsgame/team/player","hitseason","r","s_r_tot_order"],
        ["name","/bsgame/team[@vh='H']/player","hitseason","rbi","s_rbi_order"],
        ["name","/bsgame/team[@vh='V']/player","hitseason","rbi","s_rbi_order"],
        ["name","/bsgame/team/player","hitseason","rbi","s_rbi_tot_order"],
        ["name","/bsgame/team[@vh='H']/player","pchseason","so","s_so_order"],
        ["name","/bsgame/team[@vh='V']/player","pchseason","so","s_so_order"],
        ["name","/bsgame/team/player","pchseason","so","s_so_tot_order"],
        ["name","/bsgame/team[@vh='H']/player","pchseason","era","s_era_order"],
        ["name","/bsgame/team[@vh='V']/player","pchseason","era","s_era_order"],
        ["name","/bsgame/team/player","pchseason","era","s_era_tot_order"]
    ] if sport == 'baseball' || sport == 'softball'

    xpathsums = Array[
    ]
    #[sumsto,sumsfrom,valuetosum,finalsum]

    xpathsums = Array[
        ["/sogame/team","linescore/lineprd","corners","corners"],
        ["/sogame/team","linescore/lineprd","offsides","offsides"]
    ] if sport == 'msoc' || sport == 'wsoc'

    xpathlinesums = Array[
    ]

    xpathlinesums = Array[
        ["/bsgame/team/player/hitseason",["ab","bb","hbp"],"pa"],
        ["/bsgame/team/player/hitseason",["h","bb","hbp"],"obp_numerator"],
        ["/bsgame/team/player/pchseason",["h","bb","hbp"],"whip_numerator"]
    ] if sport == 'baseball' || sport == 'softball'
    #[sumsat,[valuestosum],finalsum]

    xpathfinds = Array[
    ]
    #searchroot, searchxpath, value, output (output relative to root)

    xpathfinds = Array[
        ["/bsgame","team[@vh='H']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]","name","hpitcher"],
        ["/bsgame","team[@vh='H']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]","uni","hpitchuni"],
        ["/bsgame","team[@vh='H']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pchseason","era","hera"],
        ["/bsgame","team[@vh='H']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pchseason","vsleft","hvsl"],
        ["/bsgame","team[@vh='H']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pchseason","vsright","hvsr"],
        ["/bsgame","team[@vh='H']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pchseason","win","hwin"],
        ["/bsgame","team[@vh='H']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pchseason","loss","hloss"],
        ["/bsgame","team[@vh='H']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pitching","bb","hbb"],
        ["/bsgame","team[@vh='H']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pitching","so","hso"],
        ["/bsgame","team[@vh='H']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pitching","pitches","hpitches"],
        ["/bsgame","team[@vh='H']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pitching","ip","hip"],
        ["/bsgame","team[@vh='H']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pitching","h","hh"],
        ["/bsgame","team[@vh='H']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pitching","er","her"],
        
        ["/bsgame","team[@vh='V']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]","name","vpitcher"],
        ["/bsgame","team[@vh='V']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]","uni","vpitchuni"],
        ["/bsgame","team[@vh='V']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pchseason","era","vera"],
        ["/bsgame","team[@vh='V']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pchseason","vsleft","vvsl"],
        ["/bsgame","team[@vh='V']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pchseason","vsright","vvsr"],
        ["/bsgame","team[@vh='V']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pchseason","win","vwin"],
        ["/bsgame","team[@vh='V']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pchseason","loss","vloss"],
        ["/bsgame","team[@vh='V']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pitching","bb","vbb"],
        ["/bsgame","team[@vh='V']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pitching","so","vso"],
        ["/bsgame","team[@vh='V']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pitching","pitches","vpitches"],
        ["/bsgame","team[@vh='V']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pitching","ip","vip"],
        ["/bsgame","team[@vh='V']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pitching","h","vh"],
        ["/bsgame","team[@vh='V']/player[not(preceding-sibling::player/pitching/@appear > pitching/@appear) and not(following-sibling::player/pitching/@appear > pitching/@appear) and (pitching/@appear > 0)]/pitching","er","ver"]
    ] if sport == 'baseball' || sport == 'softball'

    xpathlast = Array[
    ]
    #[sumsto,sumsfrom,valuetosum,finalsum]
    
    xpathcombines = Array[
        ["id","/bbgame/team","totals/stats","fgm","fga","-","fgraw"],
        ["id","/bbgame/team","totals/stats","fgm3","fga3","-","fg3raw"],
        ["id","/bbgame/team","totals/stats","ftm","fta","-","ftraw"]
    ]

    #[uid, xpath, stats object, stat1, stat2, concat with, output]
    xpathcombines = Array[
        ["name","/bsgame/team/player","hitting","h","ab","-","hab"]
    ] if sport == 'baseball' || sport == 'softball'

    xpathdivides = Array[
    ]

    xpathdivides = Array[
        ["/bsgame/team/player/hitseason","obp_numerator","pa","obp"],
        ["/bsgame/team/player/pchseason","whip_numerator","ip","whip"]
    ] if sport == 'baseball' || sport == 'softball'
    #[sumsat,numerator,denominator,output]

    xpathsorts.each do |xpathsort|
    #$logger.debug xpathsort
    players = doc.xpath(xpathsort[1])
    players_item = {}

    players.each do |player|
        begin
          uni = player.attribute(xpathsort[0]).value
        rescue
          newindex = rand(89999)+10000
          player.set_attribute(xpathsort[0], newindex)
          uni = player.attribute(xpathsort[0]).value
        end
        begin
        item = player.xpath(xpathsort[2]).attribute(xpathsort[3]).value.to_i
        #$logger.debug "Found player '#{uni}' with #{xpathsort[3]} value of '#{item}'"
        players_item[uni] = item
        rescue
        end
    end

    sorted_players_item = players_item.sort_by {|uni, item| item }.reverse.to_h

    players.each do |player|
        uni = player.attribute(xpathsort[0]).value
        player.set_attribute(xpathsort[4], sorted_players_item.keys.index(uni) ) unless sorted_players_item.keys.index(uni).nil?
        #$logger.debug "Found player '#{uni}' again, and their index is currently '#{sorted_players_item.keys.index(uni)}'"
    end

    end

    xpathsums.each do |xpathsum|
        #["sogame/team","linescore/lineprd","corners","corners"]
        #[sumsto,sumsfrom,valuetosum,finalsum]
        sumtos = doc.xpath(xpathsum[0])
        begin
        sumtos.each do |sumto|
            total = 0
            sumfroms = sumto.xpath(xpathsum[1])
            sumfroms.each do |sumfrom|
                total += sumfrom.attribute(xpathsum[2]).value.to_i
            end
            sumto.set_attribute(xpathsum[3], total)
        end
        rescue

        end
    end

    xpathlinesums.each do |xpathsum|
        #["/bsgame/team/player/hitseason",["h","bb","hbp"],"obp_numerator"]
        #[sumsat,[valuestosum],finalsum]
        sumats = doc.xpath(xpathsum[0])
        begin
            sumats.each do |sumat|
                    total = 0
                    xpathsum[1].each do |sumitem|
                        begin
                            total += sumat.attribute(sumitem).value.to_i
                        rescue
                        end
                    end
                    sumat.set_attribute(xpathsum[2], total)
            end
        rescue

        end
    end

    xpathdivides.each do |xpathdivide|
        # ["/bsgame/team/player/hitseason","obp_numerator","ab","obp"],
        #[sumsat,numerator,denominator,output]
        sumats = doc.xpath(xpathdivide[0])
        # begin
            sumats.each do |sumat|
                    numerator = sumat.attribute(xpathdivide[1]).value.to_i
                    # $logger.debug sumat
                    # $logger.debug "Found '#{xpathdivide[1]}' value of '#{numerator}'"
                    begin
                        denominator = sumat.attribute(xpathdivide[2]).value.to_f
                    rescue
                        denominator = 1
                    end
                    total = numerator / denominator
                    sumat.set_attribute(xpathdivide[3], total.round(3))
            end
        # rescue

        # end
    end

    xpathlast.each do |xpathsum|
        #["sogame/team","linescore/lineprd","corners","corners"]
        #[sumsto,sumsfrom,valuetosum,finalsum]
        sumtos = doc.xpath(xpathsum[0])
        begin
        sumtos.each do |sumto|
            total = 0
            sumfroms = sumto.xpath(xpathsum[1])
            sumfroms.each do |sumfrom|
            total = sumfrom.attribute(xpathsum[2]).value
            end
            sumto.set_attribute(xpathsum[3], total)
        end
        rescue

        end
    end

    xpathfinds.each do |xpathfind|
        finddoc = doc.xpath(xpathfind[0])

        finddoc.each do |findit|
          begin
            findout = findit.xpath(xpathfind[1]).attribute(xpathfind[2]).value
            findit.set_attribute(xpathfind[3], findout)
          rescue
          end
        end
    end

    xpathcombines.each do |xpathcombine|
        #[uid, xpath, stats object, stat1, stat2, concat with, output]
        # ["name","/bsgame/team/player","hitting","h","ab","-","hab"]

        combine = doc.xpath(xpathcombine[1])

        combine.each do |combiner|
            uni = combiner.attribute(xpathcombine[0]).value
            begin
            val1 = combiner.xpath(xpathcombine[2]).attribute(xpathcombine[3]).value.to_s
            val2 = combiner.xpath(xpathcombine[2]).attribute(xpathcombine[4]).value.to_s
            #$logger.debug "Found '#{uni}' with #{xpathcombine[3]} value of '#{val1}' and #{xpathcombine[4]} value of '#{val2}'"
            combined = val1 + xpathcombine[5] + val2
            #$logger.debug "Set: '#{xpathcombine[6]}' = '#{combined}'."
            combiner.set_attribute(xpathcombine[6], combined)
            rescue
            end
        end
    end

    #$logger.info "End..."

    #doc.to_xml.to_s
    output = doc.to_xml

    #$logger.info "Wrote out"
    #$logger.debug output

    output
end

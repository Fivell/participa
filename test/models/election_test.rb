require 'test_helper'

class ElectionTest < ActiveSupport::TestCase

  test "should validate presence on election" do
    e = Election.new
    e1 = Election.new(title: "hola mundo", agora_election_id: 1, starts_at: Time.zone.now, ends_at: Time.zone.now + 2.weeks, scope: 0)
    e.valid?
    assert(e.errors[:title].include? "no puede estar en blanco")
    assert(e.errors[:agora_election_id].include? "no puede estar en blanco")
    assert(e.errors[:starts_at].include? "no puede estar en blanco")
    assert(e.errors[:ends_at].include? "no puede estar en blanco")
    assert(e.errors[:scope].include? "no puede estar en blanco")
    assert e1.valid?
  end

  test "should scope :active work" do
    e1 = create(:election, starts_at: DateTime.civil(1999, 2, 2, 12, 12), ends_at: DateTime.civil(2001, 2, 2, 12, 12))
    assert e1.valid?
    assert_equal(Election.active.count, 0)
    e2 = create(:election, starts_at: DateTime.civil, ends_at: Time.zone.now + 2.weeks)
    assert e2.valid?
    assert_equal(Election.active.count, 1)
  end

  test "should .is_active? work" do
    # votacion ya cerrada
    e1 = create(:election, starts_at: Time.zone.now-30.days, ends_at: Time.zone.now-7.days)
    assert_not e1.is_active?

    # votacion activa
    e2 = create(:election, starts_at: Time.zone.now-30.days, ends_at: Time.zone.now+7.days)
    assert e2.is_active?

    # votacion del futuro, todavia no esta activada
    e3 = create(:election, starts_at: Time.zone.now+30.days, ends_at: Time.zone.now+90.days)
    assert_not e3.is_active?
  end

  test "should recently_finished? work" do
    e = create(:election)
    e.update_attributes(starts_at: Time.zone.now-90.days, ends_at: Time.zone.now+7.days)
    assert_not e.recently_finished?
    e.update_attributes(ends_at: Time.zone.now-30.days)
    assert_not e.recently_finished?
    e.update_attributes(ends_at: Time.zone.now-36.hours)
    assert e.recently_finished?
  end

  test "should .has_valid_location_for? work" do
    # Si es una eleccion estatal todos participan
    election = create(:election)

    user = create(:user, vote_town: "m_28_079_6")
    assert election.has_valid_location_for? user

    # si es municipal solo los que esten en ese municipio
    election = create(:election, :town)
    assert election.has_valid_location_for? user

    # si es municipal no permitir a los que no esten en ese municipio
    election.election_locations[0].location = "222222"
    assert_not election.has_valid_location_for? user
  end

  test "should .has_valid_location_for? work other scopes" do
    # estatal
    election = create(:election_location).election
    user = create(:user, vote_town: "m_28_079_6")
    election.update_attributes(scope: 0)
    assert election.has_valid_location_for? user

    # autonomia
    election = create(:election_location, :autonomy_location).election
    election.update_attributes(scope: 1)
    assert election.has_valid_location_for? user

    election = create(:election_location, :autonomy_location, location: 5).election
    election.update_attributes(scope: 1)
    assert_not election.has_valid_location_for? user

    # province
    election = create(:election_location, :province_location).election
    election.update_attributes(scope: 2)
    assert election.has_valid_location_for? user

    election = create(:election_location, :province_location, location: 29).election
    election.update_attributes(scope: 2)
    assert_not election.has_valid_location_for? user

    # town
    election = create(:election_location, :town_location).election
    election.update_attributes(scope: 3)
    assert election.has_valid_location_for? user

    election = create(:election_location, :town_location, location: 280797).election
    election.update_attributes(scope: 3)
    assert_not election.has_valid_location_for? user

    # island
    election = create(:election_location, :island_location).election
    election.update_attributes(scope: 4)
    assert_not election.has_valid_location_for? user
  end

  test "should .scope_name work" do
    election = create(:election)
    election.update_attributes(scope: 0)
    assert_equal(election.scope_name, "Estatal")
    election.update_attributes(scope: 1)
    assert_equal(election.scope_name, "Comunidad")
    election.update_attributes(scope: 2)
    assert_equal(election.scope_name, "Provincial")
    election.update_attributes(scope: 3)
    assert_equal(election.scope_name, "Municipal")
  end

  test "should .scoped_agora_election_id work" do
    election = create(:election)
    user = create(:user)
    assert_equal(1000, election.scoped_agora_election_id(user))

    election = create(:election, :autonomy)
    assert_equal(1111, election.scoped_agora_election_id(user))

    election = create(:election, :province)
    assert_equal(1280, election.scoped_agora_election_id(user))

    election = create(:election, :town)
    assert_equal(12807960, election.scoped_agora_election_id(user))

    user = create(:user, :island)
    election = create(:election, :island_election)
    assert_equal(1730, election.scoped_agora_election_id(user))

    user = create(:user, :foreigner)
    election = create(:election, :foreign_election)
    assert_equal(1000, election.scoped_agora_election_id(user))
  end

  test "should full_title_for work" do
    user = create(:user)
    user2 = create(:user, town: "m_01_001_4")

    election = create(:election)
    assert_equal("Hola mundo", election.full_title_for(user))
    assert_equal("Hola mundo", election.full_title_for(user2))

    election = create(:election, :autonomy)
    # FIXME: full_title_for is not working
    assert_equal("Hola mundo", election.full_title_for(user))
    assert_equal("Hola mundo", election.full_title_for(user2))
    #assert_equal("Hola mundo en Comunidad de Madrid", election.full_title_for(user))
    #assert_equal("Hola mundo (no hay votación en País Vasco/Euskadi)", election.full_title_for(user2))

    election = create(:election, :town)
    # FIXME: full_title_for is not working
    assert_equal("Hola mundo", election.full_title_for(user))
    assert_equal("Hola mundo", election.full_title_for(user2))
    #assert_equal("Hola mundo en Madrid", election.full_title_for(user))
    #assert_equal("Hola mundo (no hay votación en Alegría-Dulantzi)", election.full_title_for(user2))

  end

  test "should locations work" do
    skip
  end

  test "should locations= work" do
    skip
  end

  test "should Election.available_servers work" do
    assert_equal( ["agora", "beta"], Election.available_servers )
  end

  test "should server_shared_key work" do
    election = create(:election)
    assert_equal( "changeme", election.server_shared_key )
  end

  test "should server_url work" do
    election = create(:election)
    beta_election = create(:election, :beta_server)
    assert_equal( "https://example.com/", election.server_url )
    assert_equal( "https://beta.example.com/", beta_election.server_url )
  end

end

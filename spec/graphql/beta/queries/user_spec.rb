# typed: false
# frozen_string_literal: true

describe "GraphQL API Query" do
  describe "user" do
    context "when `username` argument is specified" do
      let!(:user) { create(:user) }
      let(:result) do
        query_string = <<~QUERY
          query {
            user(username: "#{user.username}") {
              username
            }
          }
        QUERY

        res = Beta::AnnictSchema.execute(query_string)
        pp(res) if res["errors"]
        res
      end

      it "shows user's username" do
        expect(result.dig("data", "user")).to eq(
          "username" => user.username
        )
      end
    end

    describe "`activities` field" do
      let!(:user) { create(:user) }

      context "when `orderBy` argument is specified" do
        let!(:activity1) { create(:create_episode_record_activity, user: user) }
        let!(:activity2) { create(:create_episode_record_activity, user: user) }
        let!(:activity3) { create(:create_episode_record_activity, user: user) }
        let(:result) do
          query_string = <<~QUERY
            query {
              user(username: "#{user.username}") {
                username
                activities(orderBy: { field: CREATED_AT, direction: DESC }) {
                  edges {
                    annictId
                    action
                    item {
                      __typename
                    }
                  }
                }
              }
            }
          QUERY

          res = Beta::AnnictSchema.execute(query_string)
          pp(res) if res["errors"]
          res
        end

        it "shows ordered user's activities" do
          expect(result.dig("data", "user")).to eq(
            "username" => user.username,
            "activities" => {
              "edges" => [
                {
                  "annictId" => activity3.id,
                  "action" => "CREATE",
                  "item" => {
                    "__typename" => "Record"
                  }
                },
                {
                  "annictId" => activity2.id,
                  "action" => "CREATE",
                  "item" => {
                    "__typename" => "Record"
                  }
                },
                {
                  "annictId" => activity1.id,
                  "action" => "CREATE",
                  "item" => {
                    "__typename" => "Record"
                  }
                }
              ]
            }
          )
        end
      end
    end

    describe "`works` field" do
      let!(:user) { create(:user) }

      context "when `state` argument is specified" do
        let!(:status1) { create(:status, user: user, kind: :watching) }
        let!(:status2) { create(:status, user: user, kind: :watched) }
        let!(:work1) { status1.work }
        let!(:work2) { status2.work }
        let!(:library_entry1) { create(:library_entry, user: user, work: work1, status: status1) }
        let!(:library_entry2) { create(:library_entry, user: user, work: work2, status: status2) }
        let(:result) do
          query_string = <<~QUERY
            query {
              user(username: "#{user.username}") {
                username
                works(state: WATCHING) {
                  edges {
                    node {
                      title
                    }
                  }
                }
              }
            }
          QUERY

          res = Beta::AnnictSchema.execute(query_string)
          pp(res) if res["errors"]
          res
        end

        it "shows user's activities" do
          expect(result.dig("data", "user")).to eq(
            "username" => user.username,
            "works" => {
              "edges" => [
                {
                  "node" => {
                    "title" => status1.work.title
                  }
                }
              ]
            }
          )
        end
      end
    end

    describe "`libraryEntries` フィールド" do
      let!(:user) { create(:user) }
      let!(:status1) { create(:status, user: user, kind: :watching) }
      let!(:status2) { create(:status, user: user, kind: :watched) }
      let!(:work1) { status1.work }
      let!(:work2) { status2.work }
      let!(:library_entry1) { create(:library_entry, user: user, work: work1, status: status1) }
      let!(:library_entry2) { create(:library_entry, user: user, work: work2, status: status2) }
      let!(:library_entry3) { create(:library_entry, user: user, status: nil) } # ステータス未指定
      let!(:work3) { library_entry3.work }

      context "`states` が指定されているとき" do
        let(:query_string) do
          <<~QUERY
            query {
              user(username: "#{user.username}") {
                libraryEntries(states: [WATCHING]) {
                  nodes {
                    work {
                      title
                    }
                  }
                }
              }
            }
          QUERY
        end

        it "指定したステータスのLibraryEntryが返ること" do
          result = Beta::AnnictSchema.execute(query_string)
          expect(result["errors"]).to be_nil

          expect(result.dig("data", "user")).to eq(
            "libraryEntries" => {
              "nodes" => [
                {
                  "work" => {
                    "title" => work1.title
                  }
                }
              ]
            }
          )
        end
      end

      context "`states` が指定されていないとき" do
        let(:query_string) do
          <<~QUERY
            query {
              user(username: "#{user.username}") {
                libraryEntries {
                  nodes {
                    work {
                      title
                    }
                  }
                }
              }
            }
          QUERY
        end

        it "全てのLibraryEntryが返ること" do
          result = Beta::AnnictSchema.execute(query_string)
          expect(result["errors"]).to be_nil

          expect(result.dig("data", "user")).to eq(
            "libraryEntries" => {
              "nodes" => [
                {
                  "work" => {
                    "title" => work1.title
                  }
                },
                {
                  "work" => {
                    "title" => work2.title
                  }
                },
                {
                  "work" => {
                    "title" => work3.title
                  }
                }
              ]
            }
          )
        end
      end
    end

    describe "`avatar_url` field" do
      let!(:user) { create(:user) }
      let(:result) do
        query_string = <<~QUERY
          query {
            user(username: "#{user.username}") {
              username
              avatarUrl
            }
          }
        QUERY

        res = Beta::AnnictSchema.execute(query_string)
        pp(res) if res["errors"]
        res
      end

      it "shows user's avatar image URL" do
        expect(result.dig("data", "user")).to eq(
          "username" => user.username,
          "avatarUrl" => "#{ENV.fetch("ANNICT_URL")}/dummy_image"
        )
      end
    end

    describe "`records` field" do
      context "`hasComment` の指定が無いとき" do
        it "感想がある記録と無い記録両方が返ること" do
          user = create(:user)
          work = create(:work)
          episode = create(:episode, work:)
          record_1 = create(:record, user:, work:)
          record_2 = create(:record, user:, work:)
          create(:episode_record, user:, record: record_1, work:, episode:, body: "")
          create(:episode_record, user:, record: record_2, work:, episode:, body: "おもしろかった")

          query_string = <<~QUERY
            query {
              user(username: "#{user.username}") {
                username
                records {
                  nodes {
                    comment
                  }
                }
              }
            }
          QUERY
          result = Beta::AnnictSchema.execute(query_string)

          expect(result["errors"]).to be_nil
          expect(result.dig("data", "user")).to eq(
            "username" => user.username,
            "records" => {
              "nodes" => [
                {"comment" => ""},
                {"comment" => "おもしろかった"}
              ]
            }
          )
        end
      end

      context "`hasComment: false` のとき" do
        it "感想が無い記録だけが返ること" do
          user = create(:user)
          work = create(:work)
          episode = create(:episode, work:)
          record_1 = create(:record, user:, work:)
          record_2 = create(:record, user:, work:)
          create(:episode_record, user:, record: record_1, work:, episode:, body: "")
          create(:episode_record, user:, record: record_2, work:, episode:, body: "おもしろかった")

          query_string = <<~QUERY
            query {
              user(username: "#{user.username}") {
                username
                records(hasComment: false) {
                  nodes {
                    comment
                  }
                }
              }
            }
          QUERY
          result = Beta::AnnictSchema.execute(query_string)

          expect(result["errors"]).to be_nil
          expect(result.dig("data", "user")).to eq(
            "username" => user.username,
            "records" => {
              "nodes" => [
                {"comment" => ""}
              ]
            }
          )
        end
      end

      context "`hasComment: true` のとき" do
        it "感想がある記録だけが返ること" do
          user = create(:user)
          work = create(:work)
          episode = create(:episode, work:)
          record_1 = create(:record, user:, work:)
          record_2 = create(:record, user:, work:)
          create(:episode_record, user:, record: record_1, work:, episode:, body: "")
          create(:episode_record, user:, record: record_2, work:, episode:, body: "おもしろかった")

          query_string = <<~QUERY
            query {
              user(username: "#{user.username}") {
                username
                records(hasComment: true) {
                  nodes {
                    comment
                  }
                }
              }
            }
          QUERY
          result = Beta::AnnictSchema.execute(query_string)

          expect(result["errors"]).to be_nil
          expect(result.dig("data", "user")).to eq(
            "username" => user.username,
            "records" => {
              "nodes" => [
                {"comment" => "おもしろかった"}
              ]
            }
          )
        end
      end
    end
  end
end

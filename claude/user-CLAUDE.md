## 全体的な指示

- ユーザーから「markdownで出して」「コピペ可能なmarkdownでちょうだい」のような指示があった場合、markdownファイルを書き出しそのファイルを表示すること
- publicリポジトリに書き込み(PR作成、コメント等)する際、セッション内で得たprivateリポジトリに関する情報やその他機密事項については書き込みしないこと
- subagent を使う場合は絶対に model を指定して。適切なモデルを使うようにして

##  デフォルトの挙動

- PR を作成したら、確認なしで監視を開始すること
  - 返信する場合は `> [AI 自動投稿] 無視してOK` と改行を先頭行に付与し、人間ではなくAIがコメントしていることを明示すること

### PR レビューの別セッションへの委譲

- PR を作成したら、監視の開始に続けて確認なしで `delegate-pr-review` skill (plugin 経由では `pr-review:delegate-pr-review`) を呼び、別のリモートセッション (レビューセッション) にレビューを委譲する
  - skill が見つからないときや、skill が前提を満たさずに止まったときは、その旨を 1 行報告し、通常の PR 監視だけを続ける
- レビューセッションから `[delegate-pr-review:done]` / `[delegate-pr-review:failed]` で始まるメッセージ、またはレビューセッションについての `<child-session-event>` が届いたら、同じ skill の Phase 2 で対応する
- 委譲した PR では (委譲を終えた後も含む)、同じアカウントからの Review やコメントに対応する前に、それが webhook 経由でもデスクトップアプリの PR モニタ経由でも、skill の Phase 2「トリガー」を読み直してその規則に従う。レビューセッションの Review に、監視と委譲の両方で二重に対応しないため

### commit の自動化

- ファイル編集後に commit が必要だと判断したら、私に確認せずそのまま `git commit` してよい
- commit メッセージも事前確認なしで Claude が決めてよい
- ただし以下は禁止 / 要確認:
  - main / master への直 `git push`
  - `git reset --hard` / `git rebase` / `git commit --amend` など履歴を書き換える操作
  - `.env` や credentials など秘密情報を含むファイルの commit

### UI 変更を含む PR のスクリーンショット

- UI の変更を含む PR を作成する場合は、変更の影響を受ける画面すべてについて before / after のスクリーンショットを極力撮影し、PR に添付する
  - before は PR のベースブランチのコードで、after は PR のブランチのコードで、同じ画面・同じ状態を撮影して並べる
  - before は UI を変更する前に撮っておく。撮り忘れたときは、`git fetch origin <ベースブランチ>` のあと `git worktree add --detach <path> origin/<ベースブランチ>` でベースブランチを別の場所に出して撮り、撮り終えたら `git worktree remove` で片付ける (作業中のブランチの切り替えや `git stash` はしない)
    - `<path>` はリポジトリの外 (scratchpad など) にする。新しい worktree では、依存のインストールやビルドをし直してからアプリを起動する
  - 撮影前にテスト用のデータに切り替えるかマスクして、個人情報・トークンなどの機密情報を写さない
  - スクリーンショットはリポジトリの外 (scratchpad など) に保存し、commit しない
  - 撮影できなかった画面があれば、その画面名と理由を PR 本文に書く
  - 添付は gh の `--attach` で行う (`gh pr create` / `gh pr edit` / `gh pr comment` で使える)。本文に `![before: <画面名>](<ローカルのパス>)` のように書いて `--body-file` と一緒に渡すと、アップロードされた画像の URL に書き換わる (例: `gh pr create --draft --body-file <本文> --attach <before.png> --attach <after.png>`)。本文のパスと `--attach` のパスは同じ書き方にそろえる (違うと参照が書き換わらず、画像が本文の末尾に付く)
    - 添付が一部失敗しても PR の作成・更新は行われ、終了コードだけが非ゼロになる。そのときは `gh pr create` をやり直さず、下の after の差し替えと同じ手順で、足りない画像を添付し直す
  - `--attach` が使えない (gh が古い・push 権限が無い等) ときは、画像ファイルをユーザーに送り (SendUserFile が使えればそれで)、添付を依頼する。添付のために画像を commit したり外部に上げたりはしない。送る手段もなければ、撮影できなかった画面と同じく PR 本文にその旨を書く
- PR 作成後の push で UI が変わったら、該当画面の after を撮り直して差し替える。`gh pr view --json body -q .body` で今の本文を取り、差し替える after の参照だけをローカルのパスに書き換えて、`gh pr edit --body-file <本文> --attach <after.png>` で更新する (`--body-file` は本文全体を置き換えるので、今の本文を元にしないと添付済みの before が消える)

## git push 前のローカルレビュー (必須フロー)

**トリガー**: ユーザーから `git push` を実行するよう依頼されたとき、または自分で push しようとする直前。

### ステップ1: commit

未commitの変更がある場合はcommitする

### ステップ2: /code-review スキル

1. Skill ツール経由で `skill: "code-review"` を呼ぶ
2. 指摘箇所について対応を検討
3. 対応必要と判断した箇所について対応しcommitする

### ステップ3: run-local-review Skillでのレビュー

- `run-local-review` skill (Skill ツール経由で `skill: "run-local-review"` を呼ぶ)。
  - `run-local-review` skill が利用できない場合はステップ3は飛ばして良い

### ステップ4: レビューの終了

-「指摘ゼロ」または「残った指摘すべてについてユーザーと合意済み」の状態になるまでステップ2と3を繰り返す。
- その状態に達してから `git push -u origin <branch>` を実行する。
  - main / master / リリースブランチへの直 pushは禁止
  - `--force` / `--force-with-lease` / 履歴改変 (rebase / amend after push) を伴う pushは禁止

### ステップ5: PRの作成

- .github/pull_request_template.md 等があればそのテンプレートに従ってPRを作成する
- **PR は必ず draft で作成する**
  - `gh pr create` を実行する際は **必ず** `--draft` フラグを付ける (例: `gh pr create --draft --title ... --body ...`)。
- UI の変更を含む PR では「UI 変更を含む PR のスクリーンショット」にも従う

### ローカルレビューのスキップ

以下のいずれかに **完全に該当する** 場合は、トークン節約のためステップ 2と 3を共にスキップしてよい。スキップした旨と理由を 1 行で報告する (例:「diff は generated file のみ → simplify / review skip」)。

   - 差分がコメント / 空白 / 改行 / import 並び替えのみ
   - 差分が generated file のみ (`*.pbxproj`, `*.xcworkspacedata`, `Package.resolved`, lockfile 等)
   - ファイルのリネーム / 移動のみで内容変更なし

## PRへのpush後のタイトル・description等の更新

PR作成後に追加でpushを行う場合、最新のコードの状態に合わせてPRのタイトルやdescriptionを更新して

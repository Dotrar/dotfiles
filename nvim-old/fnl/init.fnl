(module nvim-config
  {autoload {a aniseed.core 
             str aniseed.string
             Popup nui.popup
             Telescope telescope.builtin
             Shade shade
             TS nvim-treesitter
             H helpers
             Split nui.split
             autocmd nui.utils.autocmd}})

; ----------------------------
; config.fnl
; i love it 

; ~/.config/nvim/fnl/helpers.fnl

;;; Helpers 
(defn leadermap [key rhs-or-func]
  (vim.keymap.set :n (.. :<leader> key) rhs-or-func))

;;; Config

;;; Keymaps

(leadermap :<space> Telescope.buffers)
(leadermap :sf (fn [] (Telescope.find_files {:previewer false})))
(leadermap :sb Telescope.current_buffer_fuzzy_find)
(leadermap :sh Telescope.help_tags)
(leadermap :sd Telescope.grep_string)
(leadermap :sp Telescope.live_grep)
(leadermap :sl Telescope.lsp_workspace_symbols)

; (leadermap :so (fn [] (Telescope.tags {:only_current_buffer true})))
; (leadermap :sh Telescope.oldfiles)

;;; Plugin Config
(Shade.setup {:overlay_opacity 30
              :keys {:brightness_up :<C-Up>
                     :brightness_down :<C-Down>}})

;;; Custom functions and plugins

(defn vmap [key rhs]
  (vim.keymap.set :v key rhs))

(defn get-visual-selection []
  "Get visual selection - only for lines mode"
  (let [v (vim.fn.line "v")
        c (vim.fn.line ".")
        upper (math.min v c)
        lower (math.max v c)]
    (when (= :V (. (vim.api.nvim_get_mode) :mode))
      (vim.api.nvim_buf_get_lines 0 (- upper 1) lower false)    ) ))

(defn count-starting-spaces [lines]
  "Return a count matching table"
  (icollect [_ line (ipairs lines)]
    (let [(idx count) (string.find line "^%s*")]
      (when (= idx 1) count))))

(defn unindent [lines]
  "Find minimum indent"
  (let [x (math.min (unpack (count-starting-spaces lines)))]
    (if (> x 0)
      (icollect [_ line (ipairs lines)]
        (string.sub line (+ x 1)))
      lines)))

(defn send-tmux-command [args]
  (vim.fn.system (.. "tmux -L default " args)))

(defn write-to-file [lines]
  "Write to local file, with "
  (table.insert lines "")
  (vim.fn.system "cat > ~/.tmp_slime" lines))


(defn send-to-tmux [lines]
  (write-to-file lines)
  (send-tmux-command "load-buffer ~/.tmp_slime")
  (send-tmux-command "paste-buffer -d -p -t {last}")
  (send-tmux-command "last-pane")
  )

;; vim-slime like:
(vmap :<c-c><c-c> 
      (fn []
        "Send the selected text over to REPL"
        (send-to-tmux (unindent (get-visual-selection)))))

(defn kraken-keymap [key rhs-or-command]
  (vim.keymap.set :n (.. :<leader>k key) rhs-or-command))

(kraken-keymap :x (fn [] (print "lua commandx")))
(kraken-keymap :y ":echo 'vim commandy'<CR>")
(kraken-keymap :e ":e ~/.config/nvim/fnl/init.fnl<CR>")

;;


(vim.keymap.set :n :<C-C> ::vs<cr>)

(defn get-filename [] (vim.fn.expand "%"))

(defn make-matching [filename]
  "assuming we're given an octoenergy filepath, generate needed filepath alternatives")
  ; (let [territories {:aus :deu :esp :gbr :jpn :nzl :syl :usa}])
  ; (value
  ;   (string.gsub filename "aus")))

    

(make-matching "src/octoenergy/plugins/territories/aus/billing/elec_charging_calculator/_consumption.py")
(make-matching "/home/dre/init")



; ---- Renwu 任务 



; ------------------


;; Macro

(macro augroup [name ...]
  `(do
     (nvim.ex.augroup ,(tostring name))
     (nvim.ex.autocmd_)
     ,...
     (nvim.ex.augroup :END)))


(fn pop [contents close-callback]
  "Create a popup"
  (let [p (Popup {:enter true 
                  :focusable true 
                  :border {:style "rounded"} 
                  :position "50%" 
                  :size {:width "50%" 
                         :height "30%"}
                  :buf_options {:modifiable true 
                                :readonly false}})]
    (p:mount)
    (p:on autocmd.event.BufEnter
          (fn []
            (vim.keymap.set :n :t (fn [] (print "Hello!!~~")))))
    (p:on autocmd.event.BufLeave 
          (fn []
            (close-callback)
            (p:unmount)))

    (vim.api.nvim_buf_set_lines p.bufnr 0 1 false contents)))

(fn split [contents callback]
  "Create a horizontal split" 
  (let [s (Split {:relative :editor 
                  :position :bottom 
                  :size "20%"})]
    (s:mount)
    (s:on autocmd.event.BufLeave
          (fn []
            (callback)
            (s:unmount)))    

    (vim.api.nvim_buf_set_lines s.bufnr 0 1 false contents)))

(defn find-related-files [filename]
  "Find the related files to a ")


; (split ["Welcome"] (fn [] (print "Closed")))


; (pop ["Welcome to" 
;       "the wonderful world"]
;      (fn []
;        (print "Window was closed")))

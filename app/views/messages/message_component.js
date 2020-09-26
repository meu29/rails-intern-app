class App extends React.Component {

    constructor(props) {
        super(props);
        this.state = {"sended_messages": [], "received_messages": []};
        //stateの外に置く
        this.from_user_id = document.getElementsByName("from_user_id")[0].value;
        this.original_messages = {"sended_messages": [], "received_messages": []}
        this.getMessages = this.getMessages.bind(this);
        this.sendMessage = this.sendMessage.bind(this);
        this.narrowDown = this.narrowDown.bind(this);
    }

    //コンポーネントの描画後に実行
    componentDidMount() {
        this.getMessages();
    }        

    getMessages() {

            fetch("http://localhost:3000/getMessages?user_id=" + this.from_user_id)
            .then((res) => res.json())
            .then((res) => {
              this.original_messages["sended_messages"] = res["sended_messages"];
              this.original_messages["received_messages"] = res["received_messages"];
              this.setState(this.original_messages);
            })
            .catch((error) => alert(error))
            
          }

          sendMessage() {

            var body = JSON.stringify({
              "from_user_id": this.from_user_id,
              "to_user_id": document.getElementsByName("to_user_id")[0].value,
              "message": document.getElementsByName("message")[0].value,
              "date": "2020-01-11 11:38:11"//new Date()
            });

            document.getElementsByName("message")[0].value = "";
            
            var opt = {
              method: "post",
              headers: {"Content-Type": "application/json"},
              body: body
            };

            fetch("http://localhost:3000/sendMessage", opt)
            .then((res) => res.json())
            .then((res) => this.getMessages())
            .catch((error) => alert(error)) 

          } 

          narrowDown(e) {

            var keyword = e.target.value;
            
            if (keyword == "") {
              return this.setState(this.original_messages);
            }

            var sended_messages = this.original_messages["sended_messages"].filter(function(message) {
              return message["name"].indexOf(keyword) != -1 || message["message"].indexOf(keyword) != -1;
            })

            var received_messages = this.original_messages["received_messages"].filter(function(message) {
              return message["name"].indexOf(keyword) != -1 || message["message"].indexOf(keyword) != -1; 
            })

            this.setState({"sended_messages": sended_messages, "received_messages": received_messages});

          }

          render() {
            return (
              <div>
                <div id="sendMessageArea">
                  <p>メッセージを送信</p>
                  <p><label>送信先ユーザーID</label><input type="text" name="to_user_id" /></p>
                  <textarea name="message" placeholder="メッセージを入力"></textarea>
                  <input type="button" value="送信" onClick={this.sendMessage} />
                </div>
                <Tabs>
                  <TabList>
                    <Tab>受信したメッセージ</Tab>
                    <Tab>送信したメッセージ</Tab>
                  </TabList>
                  <TabPanel>
                    {this.state.received_messages.map(function(received_message) {
                      return (
                        <div>
                          <p>{"送り主 : " + received_message["name"]}</p>
                          <p>{received_message["message"]}</p>
                          <p>{received_message["date"]}</p>
                        </div>
                      );
                    })}
                  </TabPanel>
                  <TabPanel>
                    <p>送信したメッセージ</p>
                    {this.state.sended_messages.map(function(sended_message) {
                      return (
                        <div>
                          <p>{"宛先 : " + sended_message["name"]}</p>
                          <p>{sended_message["message"]}</p>
                          <p>{sended_message["date"]}</p>
                        </div>
                      );
                    })}
                  </TabPanel>
                </Tabs>
                <div>
                  <input type="text" placeholder="絞り込みキーワードを入力" onKeyUp={this.narrowDown} />
                </div>
              </div>
            )
          }

      }

      ReactDOM.render(<App />, document.getElementById("app")); 
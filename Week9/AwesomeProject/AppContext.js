import { createContext, useState } from "react";

const AppContext = createContext();

const AppContextProvider = ({ children }) => {
  const [cart, setCart] = useState([]);

  const addToCart = (product) => {
    const existingProduct = cart.find((item) => item.id === product.id);

    if (existingProduct) {
      setCart((prevItems) =>
        prevItems.map((item) =>
          item.id === product.id ? { ...item, amount: item.amount + 1 } : item
        )
      );
    } else {
      setCart((prevItems) => [...prevItems, { ...product, amount: 1 }]);
    }
  };

  const getCart = () => {
    return cart.reduce((acc, product) => {
      return acc + product.amount;
    }, 0);
  };

  return (
    <AppContext.Provider value={{ cart, addToCart, getCart }}>
      {children}
    </AppContext.Provider>
  );
};

export { AppContext, AppContextProvider };
